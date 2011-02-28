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

unit Tests.Internal.Basics;
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

type
  TTestBase = class(TTestCaseEx)
  published
    procedure TestRefCountedObjectLife();
    procedure TestRefCountedObjectExtractReference();
    procedure TestRefCountedObjectKeepObjectAlive();
    procedure TestRefCountedObjectReleaseObject();
    procedure TestRefCountedObjectExceptions();
  end;

  ICheck = interface
    procedure CheckNotConstructing();
    procedure CheckRefCountEquals(const Cnt: Integer);
  end;

  TTestRefCountedObject = class(TRefCountedObject, ICheck)
  private
    FTest: TTestBase;

  public
    constructor Create(const Test: TTestBase);

    procedure CheckNotConstructing();
    procedure CheckRefCountEquals(const Cnt: Integer);

    destructor Destroy(); override;
  end;

  TTestRules = class(TTestCaseEx)
  published
    procedure Test_Create;
    procedure Test_Custom;
    procedure Test_Default;
  end;

type
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


var
  TestDestroy: Integer;

{ TTestBase }

procedure TTestBase.TestRefCountedObjectKeepObjectAlive;
var
  Obj, Obj1, Obj2: TTestRefCountedObject;
  I1, I2: ICheck;
begin
  { ------------ No Interfaces, No destroy ----------- }
  TestDestroy := 0;

  Obj := TTestRefCountedObject.Create(Self);
  Obj1 := TTestRefCountedObject.Create(Self);
  Obj2 := TTestRefCountedObject.Create(Self);

  { Register for keep-alive }
  Obj.KeepObjectAlive(Obj1);
  Obj.KeepObjectAlive(Obj2);

  Obj.Free;
  Check(TestDestroy = 1, 'Only Obj expected to be gone!');

  { ------------ Interfaces, No chain -------------}
  TestDestroy := 0;
  Obj := TTestRefCountedObject.Create(Self);
  I1 := Obj1;
  I2 := Obj2;

  { Should not allow Obj1 and 2 to be killed! }
  Obj.KeepObjectAlive(Obj1);
  Obj.KeepObjectAlive(Obj2);

  I1 := nil;
  I2 := nil;

  Check(TestDestroy = 0, 'Expected no deaths while keeping alive!');

  Obj.Free;
  Check(TestDestroy = 3, 'Expected all objects to be killed!');

  { ------------ Interfaces, Chain -------------}
  TestDestroy := 0;
  Obj := TTestRefCountedObject.Create(Self);
  Obj1 := TTestRefCountedObject.Create(Self);
  Obj2 := TTestRefCountedObject.Create(Self);

  I1 := Obj1;
  I2 := Obj2;

  { Should not allow Obj1 and 2 to be killed! }
  Obj.KeepObjectAlive(Obj1);
  Obj1.KeepObjectAlive(Obj2);

  I1 := nil;
  I2 := nil;

  Check(TestDestroy = 0, 'Expected no deaths while keeping alive!');

  Obj.Free;
  Check(TestDestroy = 3, 'Expected all objects to be killed!');

  { ------------ Test nil's ------------ }
  TestDestroy := 0;
  Obj := TTestRefCountedObject.Create(Self);

  Obj.KeepObjectAlive(nil);
  Obj.KeepObjectAlive(nil);
  Obj.KeepObjectAlive(nil);

  Obj.Free;

  Check(TestDestroy = 1, 'Expected Obj to die properly!');
end;

procedure TTestBase.TestRefCountedObjectLife;
var
  Obj: TTestRefCountedObject;
  I, I1: ICheck;
begin
  { First types of checks }
  Obj := TTestRefCountedObject.Create(Self);
  Obj.CheckNotConstructing();
  Obj.CheckRefCountEquals(0);
  Obj.Free;

  { Interface checks }
  I := TTestRefCountedObject.Create(Self);
  I.CheckNotConstructing();
  I.CheckRefCountEquals(1);

  I1 := I;
  I.CheckRefCountEquals(2);

  I1 := nil;
  I.CheckRefCountEquals(1);

  I := nil;
end;

procedure TTestBase.TestRefCountedObjectReleaseObject;
var
  Obj, Obj1, Obj2: TTestRefCountedObject;
  I1, I2: ICheck;
begin
  { ------------ No Interfaces, No destroy ----------- }
  TestDestroy := 0;

  Obj := TTestRefCountedObject.Create(Self);
  Obj1 := TTestRefCountedObject.Create(Self);
  Obj2 := TTestRefCountedObject.Create(Self);

  { Register for keep-alive }
  Obj.KeepObjectAlive(Obj1);
  Obj.KeepObjectAlive(Obj2);

  Obj.ReleaseObject(Obj1);
  Obj.ReleaseObject(Obj2);

  Obj.Free;

  Check(TestDestroy = 1, 'Only Obj expected to be gone!');

  { ------------ No Interfaces, Destroy ----------- }
  TestDestroy := 0;

  Obj := TTestRefCountedObject.Create(Self);

  { Register for keep-alive }
  Obj.KeepObjectAlive(Obj1);
  Obj.KeepObjectAlive(Obj2);

  Obj.ReleaseObject(Obj1, true);
  Obj.ReleaseObject(Obj2, true);

  Obj.Free;

  Check(TestDestroy = 3, 'Only Obj, Obj1, Obj2 expected to be gone!');

  { ------------ Interfaces, Destroy ----------- }
  TestDestroy := 0;

  Obj := TTestRefCountedObject.Create(Self);
  Obj1 := TTestRefCountedObject.Create(Self);
  Obj2 := TTestRefCountedObject.Create(Self);

  I1 := Obj1;
  I2 := Obj2;

  { Register for keep-alive }
  Obj.KeepObjectAlive(Obj1);
  Obj.KeepObjectAlive(Obj2);

  I1 := nil;
  I2 := nil;

  Obj.ReleaseObject(Obj1);
  Obj.ReleaseObject(Obj2);

  Check(TestDestroy = 2, 'Only Obj1, Obj2 expected to be gone!');

  Obj.Free;
  Check(TestDestroy = 3, 'All Obj, Obj1, Obj2 expected to be gone!');

  { ------------ Lots of Interfaces, Destroy ----------- }
  TestDestroy := 0;

  Obj := TTestRefCountedObject.Create(Self);
  Obj1 := TTestRefCountedObject.Create(Self);
  Obj2 := TTestRefCountedObject.Create(Self);

  I1 := Obj1;
  I2 := Obj2;

  { Register for keep-alive }
  Obj.KeepObjectAlive(Obj1);
  Obj.KeepObjectAlive(Obj2);
  Obj.KeepObjectAlive(Obj1);
  Obj.KeepObjectAlive(Obj2);
  Obj.KeepObjectAlive(Obj1);
  Obj.KeepObjectAlive(Obj2);

  I1 := nil;
  I2 := nil;

  Obj.ReleaseObject(Obj1);
  Obj.ReleaseObject(Obj2);
  Check(TestDestroy = 0, 'Nothing should be gone!');

  Obj.ReleaseObject(Obj1);
  Obj.ReleaseObject(Obj2);
  Check(TestDestroy = 0, 'Nothing should be gone!');

  Obj.Free;
  Check(TestDestroy = 3, 'All Obj, Obj1, Obj2 expected to be gone!');
end;


procedure TTestBase.TestRefCountedObjectExceptions;
var
  Obj: TTestRefCountedObject;
begin
  Obj := TTestRefCountedObject.Create(self);

  CheckException(ECannotSelfReferenceException,
    procedure() begin
      Obj.KeepObjectAlive(Obj);
    end,
    'ECannotSelfReferenceException not thrown in KeepObjectAlive()'
  );

  CheckException(ECannotSelfReferenceException,
    procedure() begin
      Obj.ReleaseObject(Obj);
    end,
    'ECannotSelfReferenceException not thrown in ReleaseObject()'
  );

  Obj.Free;
end;

procedure TTestBase.TestRefCountedObjectExtractReference;
var
  Obj: TTestRefCountedObject;
  I: ICheck;
begin
  Obj := TTestRefCountedObject.Create(Self);
  Check(Obj.ExtractReference = nil, 'Expected nil!');

  I := Obj;
  Check(Obj.ExtractReference <> nil, 'Expected not nil!');

  I := nil;
end;

{ TTestRefCountedObject }

procedure TTestRefCountedObject.CheckNotConstructing;
begin
  FTest.Check(not Constructing, 'Should not be checked as Constructing!');
end;

procedure TTestRefCountedObject.CheckRefCountEquals(const Cnt: Integer);
begin
  FTest.Check(RefCount = Cnt, 'RefCount is not what it was expected to be!');
end;

constructor TTestRefCountedObject.Create(const Test: TTestBase);
begin
  Test.Check(Constructing, 'Should be checked as Constructing!');
  Test.Check(RefCount = 1, 'Ref count should be 1');
  Test.Check(ExtractReference = nil, 'No reference should be expected in ctor!');

  FTest := Test;
end;

destructor TTestRefCountedObject.Destroy;
begin
  FTest.Check(not Constructing, 'Should not be checked as Constructing!');
  Inc(TestDestroy);

  inherited;
end;

{ TTestRules }

procedure TTestRules.Test_Create;
var
  LStrRules: TRules<string>;
begin
  CheckException(EArgumentNilException,
    procedure()
    begin
      TRules<string>.Create(nil, TEqualityComparer<string>.Default)
    end,
    'EArgumentNilException not thrown in TRules<string>.Create (nil, xxx).'
  );

  CheckException(EArgumentNilException,
    procedure()
    begin
      TRules<string>.Create(TComparer<string>.Default, nil)
    end,
    'EArgumentNilException not thrown in TRules<string>.Create (xxx, nil).'
  );

  LStrRules := TRules<string>.Create(TComparer<string>.Default, StringCaseInsensitiveComparer);
  LStrRules := TRules<string>.Create(StringCaseInsensitiveComparer, TEqualityComparer<string>.Default);
end;

procedure TTestRules.Test_Custom;
var
  LStrRules: TRules<string>;
begin
  CheckException(EArgumentNilException,
    procedure()
    begin
      TRules<string>.Custom(nil)
    end,
    'EArgumentNilException not thrown in TRules<string>.Custom (nil).'
  );

  LStrRules := TRules<string>.Custom(StringCaseInsensitiveComparer);
end;

procedure TTestRules.Test_Default;
var
  LStrRules: TRules<string>;
begin
  LStrRules := TRules<string>.Default;
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

  RegisterTests('Internal.Support', [
    TTestBase.Suite,
    TTestRules.Suite
  ]);

finalization
  StringCaseInsensitiveComparer.Free;

end.
