(*
* Copyright (c) 2008-2011, Ciobanu Alexandru
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

unit Tests.Utils;
interface
uses
  SysUtils,
  TestFramework,
  Generics.Defaults,
  Collections.Base;

type
  TClassOfException = class of Exception;

  { Our test case }
  TTestCaseEx = class(TTestCase)
  protected
    procedure CheckException(const AExType: TClassOfException; const AProc: TProc; const Msg : String);
  end;

  { Special stuff }
  TTestObject = class
  private
    FBoolRef: PBoolean;
  public
    constructor Create(const BoolRef: PBoolean);
    destructor Destroy(); override;
  end;

  TInsensitiveStringComparer = class(TStringComparer)
  public
    function Compare(const Left, Right: string): Integer; override;
    function Equals(const Left, Right: string): Boolean;
      reintroduce; overload; override;
    function GetHashCode(const Value: string): Integer;
      reintroduce; overload; override;
  end;

var
  StringCaseInsensitiveComparer: TInsensitiveStringComparer;

implementation

{ TTestCaseEx }

procedure TTestCaseEx.CheckException(const AExType: TClassOfException; const AProc: TProc; const Msg: String);
var
  bWasEx : Boolean;
begin
  bWasEx := False;

  try
    { Cannot self-link }
    AProc();
  except
    on E : Exception do
    begin
       if E is AExType then
          bWasEx := True;
    end;
  end;

  Check(bWasEx, Msg);
end;

{ TTestObject }

constructor TTestObject.Create(const BoolRef: PBoolean);
begin
  BoolRef^:= false;
  FBoolRef := BoolRef;
end;

destructor TTestObject.Destroy;
begin
  FBoolRef^ := true;
  inherited;
end;

{ TInsensitiveStringComparer }

function TInsensitiveStringComparer.Compare(const Left, Right: string): Integer;
begin
  Result := CompareText(Left, Right);
end;

function TInsensitiveStringComparer.Equals(const Left, Right: string): Boolean;
begin
  Result := SameText(Left, Right);
end;

function TInsensitiveStringComparer.GetHashCode(const Value: string): Integer;
var
  Upped: string;
begin
  Upped := AnsiUpperCase(Value);
  Result := BobJenkinsHash(PChar(Upped)^, SizeOf(Char) * Length(Upped), 0);
end;

initialization
  StringCaseInsensitiveComparer := TInsensitiveStringComparer.Create;

finalization
  StringCaseInsensitiveComparer.Free;

end.
