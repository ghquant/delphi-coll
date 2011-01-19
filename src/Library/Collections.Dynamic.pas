(*
* Copyright (c) 2011, Ciobanu Alexandru
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the <organization> nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*)

unit Collections.Dynamic;
interface
uses
  SysUtils,
  Rtti,
  TypInfo;

type
  ///  <summary>Alias for Rtti's <c>TValue</c> type. The compiler seems to have a hard
  ///  time differentiating <c>TValue</c> from the generic type argument <c>TValue</c>.</summary>
  TAny = TValue;

  ///  <summary>An alias to <v>Variant</c> type. Its main purpose is to serve as a reminder that
  ///  it contains a part of an object and is to be considered "dynamic record".</summary>
  TView = Variant;

  ///  <summary>A special purpose record type that exposes a number of methods that generate
  ///  selector methods for fields and properties of a class or record types.</summary>
  Member = record
  private class var
    FViewVariantType: Word;

  private type
    {$REGION 'Internal Types'}
    TSelector<T, K> = class(TInterfacedObject, TFunc<T, K>, TFunc<T, TValue>)
    private
      FContext: TRttiContext;
      FType: TRttiType;
      FMember: TRttiMember;

    protected
      function TFunc<T, K>.Invoke = GenericInvoke;
      function TFunc<T, TValue>.Invoke = TValueInvoke;

    public
      function TValueInvoke(AFrom: T): TValue; virtual; abstract;
      function GenericInvoke(AFrom: T): K;
    end;

    TRecordFieldSelector<K> = class(TSelector<Pointer, K>)
    public
      function TValueInvoke(AFrom: Pointer): TValue; override;
    end;

    TClassFieldSelector<K> = class(TSelector<TObject, K>)
    public
      function TValueInvoke(AFrom: TObject): TValue; override;
    end;

    TClassPropertySelector<K> = class(TSelector<TObject, K>)
    public
      function TValueInvoke(AFrom: TObject): TValue; override;
    end;

    TViewSelector<T> = class(TInterfacedObject, TFunc<T, TView>)
    private
      FNames: TArray<string>;
      FFuncs: TArray<TFunc<T, TValue>>;
    public
      function Invoke(AFrom: T): TView;
    end;

    {$ENDREGION}

  public
    ///  <summary>Generates a selector for a given member name.</summary>
    ///  <param name="AName">The field or property name to select from <c>T</c>.</param>
    ///  <returns>A selector function that retrieves the field from a class or record.</returns>
    ///  <exception cref="Generics.Collections|ENotSupportedException"><paramref name="AName"/> is not a real member of record or class.</exception>
    ///  <exception cref="Generics.Collections|ENotSupportedException"><c>T</c> is not a record or class type.</exception>
    class function Name<T, K>(const AName: string): TFunc<T, K>; overload; static;

    ///  <summary>Generates a selector for a given member name.</summary>
    ///  <param name="AName">The field or property name to select from <c>T</c>.</param>
    ///  <returns>A selector function that retrieves the field from a class or record. The selected value is a <c>TValue</c> type.</returns>
    ///  <exception cref="Generics.Collections|ENotSupportedException"><paramref name="AName"/> is not a real member of record or class.</exception>
    ///  <exception cref="Generics.Collections|ENotSupportedException"><c>T</c> is not a record or class type.</exception>
    class function Name<T>(const AName: string): TFunc<T, TValue>; overload; static;

    class function Name<T>(const ANames: array of string): TFunc<T, TView>; overload; static;
  end;

implementation
uses
  Variants,
  Generics.Collections,
  Collections.Base,
  Collections.Dictionaries;

type
  { Declare the String/Variant dictionary that will hold the real data }
  TViewDictionary = TDictionary<String, TValue>;

  { Mapping the TSVDictionary into TVarData structure }
  TViewDictionaryVarData = packed record
    { Var type, will be assigned at runtime }
    VType: TVarType;
    { Reserved stuff }
    Reserved1, Reserved2, Reserved3: Word;
    { A reference to the enclosed dictionary }
    FDictionary: TViewDictionary;
    { Reserved stuff }
    Reserved4: LongWord;
  end;

  { Manager for our variant type }
  TViewDictionaryVariantType = class(TInvokeableVariantType)
  public
    procedure Clear(var V: TVarData); override;
    procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;
    function GetProperty(var Dest: TVarData; const V: TVarData; const Name: string): Boolean; override;
  end;

{ TViewDictionaryVariantType }

procedure TViewDictionaryVariantType.Clear(var V: TVarData);
begin
  { Clear the variant type }
  V.VType := varEmpty;

  { And dispose the value }
  FreeAndNil(TViewDictionaryVarData(V).FDictionary);
end;

procedure TViewDictionaryVariantType.Copy(var Dest: TVarData;
  const Source: TVarData; const Indirect: Boolean);
begin
  if Indirect and VarDataIsByRef(Source) then
    VarDataCopyNoInd(Dest, Source)
  else
  begin
    with TViewDictionaryVarData(Dest) do
    begin
      { Copy the variant type }
      VType := VarType;

      { Create a new dictionary and copy contents }
      FDictionary := TViewDictionary.Create(TViewDictionaryVarData(Source).FDictionary);
    end;
  end;
end;

function TViewDictionaryVariantType.GetProperty(var Dest: TVarData; const V: TVarData; const Name: string): Boolean;
var
  LResult: TValue;
  LVarResult: Variant;
begin
  { Type cast to our data type }
  with TViewDictionaryVarData(V) do
  begin
    { Try to read the value from the dictionary }
    if not FDictionary.TryGetValue(Name, LResult) then
      Clear(Dest) //todo, throw exception
    else begin
      LVarResult := LResult.AsVariant;
      Dest := TVarData(LVarResult);
    end;

  end;

  { Return true in any possible case }
  Result := True;
end;

var
  { Our singleton that manages our variant type }
  FViewDictionaryVariantType: TViewDictionaryVariantType;

{ Member.TSelector<T, K> }

function Member.TSelector<T, K>.GenericInvoke(AFrom: T): K;
begin
  Result := TValueInvoke(AFrom).AsType<K>();
end;

{ Member.TRecordFieldSelector<T, K> }

function Member.TRecordFieldSelector<K>.TValueInvoke(AFrom: Pointer): TValue;
begin
  ASSERT(Assigned(FMember));
  ASSERT(FMember is TRttiField);

  Result := TRttiField(FMember).GetValue(AFrom);
end;

{ Member.TClassFieldSelector<K> }

function Member.TClassFieldSelector<K>.TValueInvoke(AFrom: TObject): TValue;
begin
  ASSERT(Assigned(FMember));
  ASSERT(FMember is TRttiField);

  Result := TRttiField(FMember).GetValue(AFrom);
end;

{ Member.TClassPropertySelector<K> }

function Member.TClassPropertySelector<K>.TValueInvoke(AFrom: TObject): TValue;
begin
  ASSERT(Assigned(FMember));
  ASSERT(FMember is TRttiProperty);

  Result := TRttiProperty(FMember).GetValue(AFrom);
end;

{ Member.TViewSelector<T> }

function Member.TViewSelector<T>.Invoke(AFrom: T): TView;
var
  I: NativeInt;
begin
  { Initialize a view }
  VarClear(Result);

  with TVarData(Result) do
  begin
    VType := Member.FViewVariantType;
    VPointer := TViewDictionary.Create();

    { Copy selected fields over }
    for I := 0 to Length(FFuncs) - 1 do
      TViewDictionary(VPointer)[FNames[I]] := FFuncs[I](AFrom);
  end;
end;

{ Member }

class function Member.Name<T, K>(const AName: string): TFunc<T, K>;
var
  LT, LK: PTypeInfo;
  LContext: TRttiContext;
  LType: TRttiType;
  LMember: TRttiMember;
  LSelector: TSelector<T, K>;
begin
  { Get the type }
  LT := TypeInfo(T);
  LK := TypeInfo(K);

  LType := LContext.GetType(LT);

  { Check for correctness }
  if not Assigned(LType) or not (LType.TypeKind in [tkClass, tkRecord]) then
    ExceptionHelper.Throw_TypeNotAClassOrRecordError(GetTypeName(LT));

  if LType.TypeKind = tkRecord then
  begin
    LMember := LType.GetField(AName);

    if not Assigned(LMember) then
      ExceptionHelper.Throw_TypeClassOrRecordDoesNotHaveMemberError(GetTypeName(LT), AName);

    LSelector := TSelector<T, K>(TRecordFieldSelector<K>.Create());
  end else
  if LType.TypeKind = tkClass then
  begin
    LMember := LType.GetField(AName);

    if Assigned(LMember) then
      LSelector := TSelector<T, K>(TClassFieldSelector<K>.Create())
    else begin
      LMember := LType.GetProperty(AName);

      if not Assigned(LMember) then
        ExceptionHelper.Throw_TypeClassOrRecordDoesNotHaveMemberError(GetTypeName(LT), AName);

      LSelector := TSelector<T, K>(TClassPropertySelector<K>.Create());
    end;
  end;

  { Upload selector }
  LSelector.FContext := LContext;
  LSelector.FType := LType;
  LSelector.FMember := LMember;

  Result := LSelector;
end;

class function Member.Name<T>(const AName: string): TFunc<T, TValue>;
begin
  Result := Member.Name<T, TValue>(AName);
end;

class function Member.Name<T>(const ANames: array of string): TFunc<T, TView>;
var
  LSelector: TViewSelector<T>;
  I, L: NativeInt;
begin
  LSelector := TViewSelector<T>.Create;
  try
    L := Length(ANames);

    { Prepare the array of selectors }
    SetLength(LSelector.FNames, L);
    SetLength(LSelector.FFuncs, L);

    { Create the array }
    for I := 0 to L - 1 do
    begin
      LSelector.FNames[I] := AnsiUpperCase(ANames[I]);
      LSelector.FFuncs[I] := Member.Name<T, TValue>(ANames[I]);
    end;

    Result := LSelector;
  except
    LSelector.Free;

    raise;
  end;
end;

initialization
  { Register our custom variant type }
  FViewDictionaryVariantType := TViewDictionaryVariantType.Create();
  Member.FViewVariantType := FViewDictionaryVariantType.VarType;

finalization
  { Uregister our custom variant }
  FreeAndNil(FViewDictionaryVariantType);

end.
