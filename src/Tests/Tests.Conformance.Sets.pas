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

unit Tests.Conformance.Sets;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Lists,
     Collections.Sets;

type
  TConformance_THashSet = class(TConformance_ISet)
  protected
    procedure SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TLinkedSet = class(TConformance_ISet)
  protected
    procedure SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TSortedSet = class(TConformance_ISet)
  protected
    function GetSortOrder(): Boolean; virtual; abstract;
    procedure SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TSortedSet_Asc = class(TConformance_TSortedSet)
  protected
    function GetSortOrder(): Boolean; override;
  end;

  TConformance_TSortedSet_Desc = class(TConformance_TSortedSet)
  protected
    function GetSortOrder(): Boolean; override;
  end;

  TConformance_TArraySet = class(TConformance_ISet)
  protected
    function GetSortOrder(): Boolean; virtual; abstract;
    procedure SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TArraySet_Asc = class(TConformance_TArraySet)
  protected
    function GetSortOrder(): Boolean; override;
  end;

  TConformance_TArraySet_Desc = class(TConformance_TArraySet)
  protected
    function GetSortOrder(): Boolean; override;
  end;

  TConformance_TBitSet = class(TConformance_ISet)
  private type
    TBitSetAdapter = class(TAbstractOperableCollection<NativeInt>, ISet<NativeInt>)
    private type
      TEnumerator = class(TAbstractEnumerator<NativeInt>)
      private
        FEnumerator: IEnumerator<Word>;
      public
        function TryMoveNext(out ACurrent: NativeInt): Boolean; override;
      end;

    private
      FBitSet: TBitSet;

      class function i2w(const AInt: NativeInt): Word;
      class function w2i(const AWord: Word): NativeInt;
      class function ic2w(const ACollection: IEnumerable<NativeInt>): IEnumerable<Word>;
    public
      constructor Create(const AAscending: Boolean);

      function GetCount(): NativeInt; override;
      function GetEnumerator(): IEnumerator<NativeInt>; override;
      procedure CopyTo(var AArray: array of NativeInt; const AStartIndex: NativeInt); overload; override;
      function Empty(): Boolean; override;
      function Max(): NativeInt; override;
      function Min(): NativeInt; override;
      function First(): NativeInt; override;
      function FirstOrDefault(const ADefault: NativeInt): NativeInt; override;
      function Last(): NativeInt; override;
      function LastOrDefault(const ADefault: NativeInt): NativeInt; override;
      function Single(): NativeInt; override;
      function SingleOrDefault(const ADefault: NativeInt): NativeInt; override;
      function Aggregate(const AAggregator: TFunc<NativeInt, NativeInt, NativeInt>): NativeInt; override;
      function AggregateOrDefault(const AAggregator: TFunc<NativeInt, NativeInt, NativeInt>; const ADefault: NativeInt): NativeInt; override;
      function ElementAt(const AIndex: NativeInt): NativeInt; override;
      function ElementAtOrDefault(const AIndex: NativeInt; const ADefault: NativeInt): NativeInt; override;
      function Any(const APredicate: TPredicate<NativeInt>): Boolean; override;
      function All(const APredicate: TPredicate<NativeInt>): Boolean; override;
      function EqualsTo(const ACollection: IEnumerable<NativeInt>): Boolean; override;

      function Version(): NativeInt; override;
      procedure Clear(); override;
      procedure Add(const AValue: NativeInt); override;
      procedure AddAll(const ACollection: IEnumerable<NativeInt>); override;
      procedure Remove(const AValue: NativeInt); override;
      procedure RemoveAll(const ACollection: IEnumerable<NativeInt>); override;
      function Contains(const AValue: NativeInt): Boolean; override;
      function ContainsAll(const ACollection: IEnumerable<NativeInt>): Boolean; override;
    end;

    procedure RemoveNotification(const AValue: Word);
  protected
    function GetSortOrder(): Boolean; virtual; abstract;
    procedure SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TBitSet_Asc = class(TConformance_TBitSet)
  protected
    function GetSortOrder(): Boolean; override;
  end;

  TConformance_TBitSet_Desc = class(TConformance_TBitSet)
  protected
    function GetSortOrder(): Boolean; override;
  end;


implementation

{ TConformance_THashSet }

procedure TConformance_THashSet.SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: THashSet<NativeInt>;
begin
  AElements := GenerateUniqueRandomElements();
  AOrdering := oNone;

  LEmpty := THashSet<NativeInt>.Create(); LEmpty.RemoveNotification := RemoveNotification;
  LOne := THashSet<NativeInt>.Create(); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := THashSet<NativeInt>.Create(); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TSortedSet }

procedure TConformance_TSortedSet.SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TSortedSet<NativeInt>;
begin
  AElements := GenerateUniqueRandomElements();
  AOrdering := oNone;

  LEmpty := TSortedSet<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TSortedSet<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TSortedSet<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TSortedSet_Asc }

function TConformance_TSortedSet_Asc.GetSortOrder: Boolean;
begin
  Result := True;
end;

{ TConformance_TSortedSet_Desc }

function TConformance_TSortedSet_Desc.GetSortOrder: Boolean;
begin
  Result := False;
end;

{ TConformance_TLinkedSet }

procedure TConformance_TLinkedSet.SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TLinkedSet<NativeInt>;
begin
  AElements := GenerateUniqueRandomElements();
  AOrdering := oNone;

  LEmpty := TLinkedSet<NativeInt>.Create(); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TLinkedSet<NativeInt>.Create(); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TLinkedSet<NativeInt>.Create(); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TArraySet }

procedure TConformance_TArraySet.SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TArraySet<NativeInt>;
begin
  AElements := GenerateUniqueRandomElements();
  AOrdering := oNone;

  LEmpty := TArraySet<NativeInt>.Create(TRules<NativeInt>.Default, 0, GetSortOrder); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TArraySet<NativeInt>.Create(TRules<NativeInt>.Default, 0, GetSortOrder); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TArraySet<NativeInt>.Create(TRules<NativeInt>.Default, 0, GetSortOrder); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TArraySet_Asc }

function TConformance_TArraySet_Asc.GetSortOrder: Boolean;
begin
  Result := True;
end;

{ TConformance_TArraySet_Desc }

function TConformance_TArraySet_Desc.GetSortOrder: Boolean;
begin
  Result := False;
end;

{ TConformance_TBitSet.TBitSetAdapter }

procedure TConformance_TBitSet.TBitSetAdapter.Add(const AValue: NativeInt);
begin
  FBitSet.Add(i2w(AValue));
end;

procedure TConformance_TBitSet.TBitSetAdapter.AddAll(const ACollection: IEnumerable<NativeInt>);
begin
  FBitSet.AddAll(ic2w(ACollection));
end;

function TConformance_TBitSet.TBitSetAdapter.Aggregate(const AAggregator: TFunc<NativeInt, NativeInt, NativeInt>): NativeInt;
begin
  if not Assigned(AAggregator) then
    Result := w2i(FBitSet.Aggregate(nil))
  else
    Result := w2i(FBitSet.Aggregate(
      function(ALeft, ARight: Word): Word
      begin
        Result := i2w(AAggregator(w2i(ALeft), w2i(ARight)));
      end
    ));
end;

function TConformance_TBitSet.TBitSetAdapter.AggregateOrDefault(
  const AAggregator: TFunc<NativeInt, NativeInt, NativeInt>;
  const ADefault: NativeInt): NativeInt;
begin
  if not Assigned(AAggregator) then
    Result := w2i(FBitSet.AggregateOrDefault(nil, i2w(ADefault)))
  else
    Result := w2i(FBitSet.AggregateOrDefault(
      function(ALeft, ARight: Word): Word
      begin
        Result := i2w(AAggregator(w2i(ALeft), w2i(ARight)));
      end,
      i2w(ADefault)
    ));
end;

function TConformance_TBitSet.TBitSetAdapter.All(const APredicate: TPredicate<NativeInt>): Boolean;
begin
  if not Assigned(APredicate) then
    Result := FBitSet.All(nil)
  else
  Result := FBitSet.All(
    function(AValue: Word): Boolean
    begin
      Result := APredicate(w2i(AValue));
    end
  );
end;

function TConformance_TBitSet.TBitSetAdapter.Any(const APredicate: TPredicate<NativeInt>): Boolean;
begin
  if not Assigned(APredicate) then
    Result := FBitSet.Any(nil)
  else
  Result := FBitSet.Any(
    function(AValue: Word): Boolean
    begin
      Result := APredicate(w2i(AValue));
    end
  );
end;

procedure TConformance_TBitSet.TBitSetAdapter.Clear;
begin
  FBitSet.Clear();
end;

function TConformance_TBitSet.TBitSetAdapter.Contains(const AValue: NativeInt): Boolean;
begin
  Result := FBitSet.Contains(i2w(AValue));
end;

function TConformance_TBitSet.TBitSetAdapter.ContainsAll(const ACollection: IEnumerable<NativeInt>): Boolean;
begin
  Result := FBitSet.ContainsAll(ic2w(ACollection));
end;

procedure TConformance_TBitSet.TBitSetAdapter.CopyTo(var AArray: array of NativeInt; const AStartIndex: NativeInt);
var
  I: NativeInt;
  LTemp: array of Word;
begin
  SetLength(LTemp, Length(AArray));
  FBitSet.CopyTo(LTemp, AStartIndex);

  for I := AStartIndex to AStartIndex + FBitSet.Count - 1 do
    AArray[I] := w2i(LTemp[I]);
end;

constructor TConformance_TBitSet.TBitSetAdapter.Create(const AAscending: Boolean);
begin
  FBitSet := TBitSet.Create(AAscending);
end;

function TConformance_TBitSet.TBitSetAdapter.ElementAt(const AIndex: NativeInt): NativeInt;
begin
  Result := w2i(FBitSet.ElementAt(AIndex));
end;

function TConformance_TBitSet.TBitSetAdapter.ElementAtOrDefault(const AIndex: NativeInt; const ADefault: NativeInt): NativeInt;
begin
  Result := w2i(FBitSet.ElementAtOrDefault(AIndex, i2w(ADefault)));
end;

function TConformance_TBitSet.TBitSetAdapter.Empty: Boolean;
begin
  Result := FBitSet.Empty;
end;

function TConformance_TBitSet.TBitSetAdapter.EqualsTo(const ACollection: IEnumerable<NativeInt>): Boolean;
begin
  Result := FBitSet.EqualsTo(ic2w(ACollection));
end;

function TConformance_TBitSet.TBitSetAdapter.First: NativeInt;
begin
  Result := w2i(FBitSet.First);
end;

function TConformance_TBitSet.TBitSetAdapter.FirstOrDefault(const ADefault: NativeInt): NativeInt;
begin
  Result := w2i(FBitSet.FirstOrDefault(i2w(ADefault)));
end;

function TConformance_TBitSet.TBitSetAdapter.GetCount: NativeInt;
begin
  Result := FBitSet.Count;
end;

function TConformance_TBitSet.TBitSetAdapter.GetEnumerator: IEnumerator<NativeInt>;
var
  LEnum: TEnumerator;
begin
  LEnum := TEnumerator.Create(Self);
  LEnum.FEnumerator := FBitSet.GetEnumerator;
  Result := LEnum;
end;

class function TConformance_TBitSet.TBitSetAdapter.i2w(const AInt: NativeInt): Word;
begin
  Result := Word(SmallInt(AInt));
end;

class function TConformance_TBitSet.TBitSetAdapter.ic2w(const ACollection: IEnumerable<NativeInt>): IEnumerable<Word>;
var
  LList: IList<Word>;
  I: NativeInt;
begin
  if not Assigned(ACollection) then
    Exit(nil);

  LList := TList<Word>.Create;
  for I in ACollection do
    LList.Add(i2w(I));

  Result := LList;
end;

function TConformance_TBitSet.TBitSetAdapter.Last: NativeInt;
begin
  Result := w2i(FBitSet.Last);
end;

function TConformance_TBitSet.TBitSetAdapter.LastOrDefault(const ADefault: NativeInt): NativeInt;
begin
  Result := w2i(FBitSet.LastOrDefault(i2w(ADefault)));
end;

function TConformance_TBitSet.TBitSetAdapter.Max: NativeInt;
begin
  Result := w2i(FBitSet.Max);
end;

function TConformance_TBitSet.TBitSetAdapter.Min: NativeInt;
begin
  Result := w2i(FBitSet.Min);
end;

procedure TConformance_TBitSet.TBitSetAdapter.Remove(const AValue: NativeInt);
begin
  FBitSet.Remove(i2w(AValue));
end;

procedure TConformance_TBitSet.TBitSetAdapter.RemoveAll(const ACollection: IEnumerable<NativeInt>);
begin
  FBitSet.RemoveAll(ic2w(ACollection));
end;

function TConformance_TBitSet.TBitSetAdapter.Single: NativeInt;
begin
  Result := w2i(FBitSet.Single);
end;

function TConformance_TBitSet.TBitSetAdapter.SingleOrDefault(const ADefault: NativeInt): NativeInt;
begin
  Result := w2i(FBitSet.SingleOrDefault(i2w(ADefault)));
end;

function TConformance_TBitSet.TBitSetAdapter.Version: NativeInt;
begin
  Result := FBitSet.Version;
end;

class function TConformance_TBitSet.TBitSetAdapter.w2i(const AWord: Word): NativeInt;
begin
  Result := SmallInt(Word(AWord));
end;

{ TBitSetAdapter.TEnumerator }


function TConformance_TBitSet.TBitSetAdapter.TEnumerator.TryMoveNext(out ACurrent: NativeInt): Boolean;
begin
  Result := FEnumerator.MoveNext;
  if Result then
    ACurrent := w2i(FEnumerator.Current);
end;

{ TConformance_TBitSet }

procedure TConformance_TBitSet.RemoveNotification(const AValue: Word);
begin
  inherited RemoveNotification(TBitSetAdapter.w2i(AValue));
end;

procedure TConformance_TBitSet.SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: Word;
  I: NativeInt;
  LEmpty, LOne, LFull: TBitSetAdapter;
begin
  AElements := GenerateUniqueRandomElements();
  AOrdering := oNone;

  LEmpty := TBitSetAdapter.Create(GetSortOrder); LEmpty.FBitSet.RemoveNotification := RemoveNotification;
  LOne := TBitSetAdapter.Create(GetSortOrder); LOne.FBitSet.RemoveNotification := RemoveNotification;
  LFull := TBitSetAdapter.Create(GetSortOrder); LFull.FBitSet.RemoveNotification := RemoveNotification;

  for I := 0 to Length(AElements) - 1 do
  begin
    LItem := TBitSetAdapter.i2w(AElements[I]);
    AElements[I] := TBitSetAdapter.w2i(LItem);
    LFull.FBitSet.Add(LItem);
  end;

  LOne.FBitSet.Add(AElements[0]);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TBitSet_Asc }

function TConformance_TBitSet_Asc.GetSortOrder: Boolean;
begin
  Result := True;
end;

{ TConformance_TBitSet_Desc }

function TConformance_TBitSet_Desc.GetSortOrder: Boolean;
begin
  Result := False;
end;

initialization
  RegisterTests('Conformance.Simple.Sets', [
    TConformance_THashSet.Suite,
    TConformance_TLinkedSet.Suite,
    TConformance_TSortedSet_Asc.Suite,
    TConformance_TSortedSet_Desc.Suite,
    TConformance_TArraySet_Asc.Suite,
    TConformance_TArraySet_Desc.Suite,
    TConformance_TBitSet_Asc.Suite,
    TConformance_TBitSet_Desc.Suite

  ]);

end.

