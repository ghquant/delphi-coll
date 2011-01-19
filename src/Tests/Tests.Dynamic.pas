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

unit Tests.Dynamic;
interface
uses SysUtils,
     Rtti,
     Tests.Utils,
     TestFramework,
     Generics.Collections,
     Collections.Dynamic,
     Collections.Base,
     Collections.Lists;

type
  TTestMember = class(TTestCaseEx)
  published
    procedure Test_Name_TView;
    procedure Test_Name_TValue;
    procedure Test_Name;
 end;

  TTestDynamic = class(TTestCaseEx)
  published
    procedure Test_Select_Exceptions;

    procedure Test_Select_Class_ByField_TValue;
    procedure Test_Select_Class_ByProp_TValue;
    procedure Test_Select_Record_ByField_TValue;

    procedure Test_Select_Class_ByField;
    procedure Test_Select_Class_ByProp;
    procedure Test_Select_Record_ByField;
 end;

type
  TCompositeObject = class
    FInteger: Integer;
    FString: string;

    property _Integer: Integer read FInteger;
    property _String: string read FString;

    constructor Create(const AInteger: Integer; const AString: string);
  end;

type
  TCompositeRecord = class
    FInteger: Integer;
    FString: string;

    constructor Create(const AInteger: Integer; const AString: string);
  end;

implementation

{ TCompositeObject }

constructor TCompositeObject.Create(const AInteger: Integer; const AString: string);
begin
  FInteger := AInteger;
  FString := AString;
end;

{ TCompositeObject }

constructor TCompositeRecord.Create(const AInteger: Integer; const AString: string);
begin
  FInteger := AInteger;
  FString := AString;
end;

{ TTestDynamic }

procedure TTestDynamic.Test_Select_Class_ByField;
var
  LList: TObjectList<TCompositeObject>;
  LSelectedInts: TList<Integer>;
  LSelectedStrs: TList<string>;
begin
  LList := TObjectList<TCompositeObject>.Create;
  LList.OwnsObjects := True;

  { Populate }
  LList.Add(TCompositeObject.Create(111, '111'));
  LList.Add(TCompositeObject.Create(222, '222'));
  LList.Add(TCompositeObject.Create(888, '888'));
  LList.Add(TCompositeObject.Create(444, '444'));
  LList.Add(TCompositeObject.Create(999, '999'));

  { Select only integers }
  LSelectedInts := TList<Integer>.Create(LList.Op.Select<Integer>('FInteger'));

  CheckEquals(5, LSelectedInts.Count);
  CheckEquals(111, LSelectedInts[0]);
  CheckEquals(222, LSelectedInts[1]);
  CheckEquals(888, LSelectedInts[2]);
  CheckEquals(444, LSelectedInts[3]);
  CheckEquals(999, LSelectedInts[4]);

  LSelectedStrs := TList<string>.Create(LList.Op.Select<string>('FString'));

  CheckEquals(5, LSelectedStrs.Count);
  CheckEquals('111', LSelectedStrs[0]);
  CheckEquals('222', LSelectedStrs[1]);
  CheckEquals('888', LSelectedStrs[2]);
  CheckEquals('444', LSelectedStrs[3]);
  CheckEquals('999', LSelectedStrs[4]);

  LSelectedStrs.Free;
  LSelectedInts.Free;
  LList.Free;
end;

procedure TTestDynamic.Test_Select_Class_ByField_TValue;
var
  LList: TObjectList<TCompositeObject>;
  LSelected: TList<TValue>;
begin
  LList := TObjectList<TCompositeObject>.Create;
  LList.OwnsObjects := True;

  { Populate }
  LList.Add(TCompositeObject.Create(111, '111'));
  LList.Add(TCompositeObject.Create(222, '222'));
  LList.Add(TCompositeObject.Create(888, '888'));
  LList.Add(TCompositeObject.Create(444, '444'));
  LList.Add(TCompositeObject.Create(999, '999'));

  { Select only integers }
  LSelected := TList<TValue>.Create(LList.Op.Select('FInteger'));

  CheckEquals(5, LSelected.Count);
  CheckEquals(111, LSelected[0].AsInteger);
  CheckEquals(222, LSelected[1].AsInteger);
  CheckEquals(888, LSelected[2].AsInteger);
  CheckEquals(444, LSelected[3].AsInteger);
  CheckEquals(999, LSelected[4].AsInteger);

  LSelected.Clear();
  LSelected.Add(LList.Op.Select('FString'));

  CheckEquals(5, LSelected.Count);
  CheckEquals('111', LSelected[0].AsString);
  CheckEquals('222', LSelected[1].AsString);
  CheckEquals('888', LSelected[2].AsString);
  CheckEquals('444', LSelected[3].AsString);
  CheckEquals('999', LSelected[4].AsString);

  LSelected.Free;
  LList.Free;
end;

procedure TTestDynamic.Test_Select_Class_ByProp;
var
  LList: TObjectList<TCompositeObject>;
  LSelectedInts: TList<Integer>;
  LSelectedStrs: TList<string>;
begin
  LList := TObjectList<TCompositeObject>.Create;
  LList.OwnsObjects := True;

  { Populate }
  LList.Add(TCompositeObject.Create(111, '111'));
  LList.Add(TCompositeObject.Create(222, '222'));
  LList.Add(TCompositeObject.Create(888, '888'));
  LList.Add(TCompositeObject.Create(444, '444'));
  LList.Add(TCompositeObject.Create(999, '999'));

  { Select only integers }
  LSelectedInts := TList<Integer>.Create(LList.Op.Select<Integer>('_Integer'));

  CheckEquals(5, LSelectedInts.Count);
  CheckEquals(111, LSelectedInts[0]);
  CheckEquals(222, LSelectedInts[1]);
  CheckEquals(888, LSelectedInts[2]);
  CheckEquals(444, LSelectedInts[3]);
  CheckEquals(999, LSelectedInts[4]);

  LSelectedStrs := TList<string>.Create(LList.Op.Select<string>('_String'));

  CheckEquals(5, LSelectedStrs.Count);
  CheckEquals('111', LSelectedStrs[0]);
  CheckEquals('222', LSelectedStrs[1]);
  CheckEquals('888', LSelectedStrs[2]);
  CheckEquals('444', LSelectedStrs[3]);
  CheckEquals('999', LSelectedStrs[4]);

  LSelectedStrs.Free;
  LSelectedInts.Free;
  LList.Free;
end;

procedure TTestDynamic.Test_Select_Class_ByProp_TValue;
var
  LList: TObjectList<TCompositeObject>;
  LSelected: TList<TValue>;
begin
  LList := TObjectList<TCompositeObject>.Create;
  LList.OwnsObjects := True;

  { Populate }
  LList.Add(TCompositeObject.Create(111, '111'));
  LList.Add(TCompositeObject.Create(222, '222'));
  LList.Add(TCompositeObject.Create(888, '888'));
  LList.Add(TCompositeObject.Create(444, '444'));
  LList.Add(TCompositeObject.Create(999, '999'));

  { Select only integers }
  LSelected := TList<TValue>.Create(LList.Op.Select('_Integer'));

  CheckEquals(5, LSelected.Count);
  CheckEquals(111, LSelected[0].AsInteger);
  CheckEquals(222, LSelected[1].AsInteger);
  CheckEquals(888, LSelected[2].AsInteger);
  CheckEquals(444, LSelected[3].AsInteger);
  CheckEquals(999, LSelected[4].AsInteger);

  LSelected.Clear();
  LSelected.Add(LList.Op.Select('_String'));

  CheckEquals(5, LSelected.Count);
  CheckEquals('111', LSelected[0].AsString);
  CheckEquals('222', LSelected[1].AsString);
  CheckEquals('888', LSelected[2].AsString);
  CheckEquals('444', LSelected[3].AsString);
  CheckEquals('999', LSelected[4].AsString);

  LSelected.Free;
  LList.Free;
end;

procedure TTestDynamic.Test_Select_Exceptions;
var
  LList: TList<Integer>;
  LObjList: TObjectList<TCompositeObject>;
begin
  LList := TList<Integer>.Create;
  CheckException(ENotSupportedException,
    procedure() begin
      LList.Op.Select('Loloi');
    end,
    'ENotSupportedException not thrown in Select(integer).'
  );

  CheckException(ENotSupportedException,
    procedure() begin
      LList.Op.Select<integer>('Loloi');
    end,
    'ENotSupportedException not thrown in Select<integer>(integer).'
  );
  LList.Free;

  LObjList := TObjectList<TCompositeObject>.Create;
  CheckException(ENotSupportedException,
    procedure() begin
      LObjList.Op.Select('FCucu');
    end,
    'ENotSupportedException not thrown in Select(field/prop not there).'
  );

  CheckException(ENotSupportedException,
    procedure() begin
      LObjList.Op.Select<integer>('FCucu');
    end,
    'ENotSupportedException not thrown in Select<integer>(field/prop not there).'
  );
  LObjList.Free;
end;

procedure TTestDynamic.Test_Select_Record_ByField;
var
  LList: TList<TCompositeRecord>;
  LSelectedInts: TList<Integer>;
  LSelectedStrs: TList<string>;
begin
  LList := TObjectList<TCompositeRecord>.Create;

  { Populate }
  LList.Add(TCompositeRecord.Create(111, '111'));
  LList.Add(TCompositeRecord.Create(222, '222'));
  LList.Add(TCompositeRecord.Create(888, '888'));
  LList.Add(TCompositeRecord.Create(444, '444'));
  LList.Add(TCompositeRecord.Create(999, '999'));

  { Select only integers }
  LSelectedInts := TList<Integer>.Create(LList.Op.Select<Integer>('FInteger'));

  CheckEquals(5, LSelectedInts.Count);
  CheckEquals(111, LSelectedInts[0]);
  CheckEquals(222, LSelectedInts[1]);
  CheckEquals(888, LSelectedInts[2]);
  CheckEquals(444, LSelectedInts[3]);
  CheckEquals(999, LSelectedInts[4]);

  LSelectedStrs := TList<string>.Create(LList.Op.Select<string>('FString'));

  CheckEquals(5, LSelectedStrs.Count);
  CheckEquals('111', LSelectedStrs[0]);
  CheckEquals('222', LSelectedStrs[1]);
  CheckEquals('888', LSelectedStrs[2]);
  CheckEquals('444', LSelectedStrs[3]);
  CheckEquals('999', LSelectedStrs[4]);

  LSelectedStrs.Free;
  LSelectedInts.Free;
  LList.Free;
end;

procedure TTestDynamic.Test_Select_Record_ByField_TValue;
var
  LList: TList<TCompositeRecord>;
  LSelected: TList<TValue>;
begin
  LList := TObjectList<TCompositeRecord>.Create;

  { Populate }
  LList.Add(TCompositeRecord.Create(111, '111'));
  LList.Add(TCompositeRecord.Create(222, '222'));
  LList.Add(TCompositeRecord.Create(888, '888'));
  LList.Add(TCompositeRecord.Create(444, '444'));
  LList.Add(TCompositeRecord.Create(999, '999'));

  { Select only integers }
  LSelected := TList<TValue>.Create(LList.Op.Select('FInteger'));

  CheckEquals(5, LSelected.Count);
  CheckEquals(111, LSelected[0].AsInteger);
  CheckEquals(222, LSelected[1].AsInteger);
  CheckEquals(888, LSelected[2].AsInteger);
  CheckEquals(444, LSelected[3].AsInteger);
  CheckEquals(999, LSelected[4].AsInteger);

  LSelected.Clear();
  LSelected.Add(LList.Op.Select('FString'));

  CheckEquals(5, LSelected.Count);
  CheckEquals('111', LSelected[0].AsString);
  CheckEquals('222', LSelected[1].AsString);
  CheckEquals('888', LSelected[2].AsString);
  CheckEquals('444', LSelected[3].AsString);
  CheckEquals('999', LSelected[4].AsString);

  LSelected.Free;
  LList.Free;
end;

{ TTestMember }

procedure TTestMember.Test_Name;
var
  LObj: TCompositeObject;
  LRec: TCompositeRecord;
begin
  Check(not Assigned(
    Member.Name<Integer>('haha')
  ));

  Check(not Assigned(
    Member.Name<TCompositeRecord>('Habla')
  ));

  Check(not Assigned(
    Member.Name<TCompositeObject>('Habla')
  ));

  LObj := TCompositeObject.Create(123, '123');
  LRec := TCompositeRecord.Create(123, '123');

  CheckEquals(123, Member.Name<TCompositeObject, Integer>('FInteger')(LObj));
  CheckEquals('123', Member.Name<TCompositeObject, string>('FString')(LObj));
  CheckEquals(123, Member.Name<TCompositeObject, Integer>('_Integer')(LObj));
  CheckEquals('123', Member.Name<TCompositeObject, string>('_String')(LObj));

  CheckEquals(123, Member.Name<TCompositeRecord, Integer>('FInteger')(LRec));
  CheckEquals('123', Member.Name<TCompositeRecord, string>('FString')(LRec));

  LObj.Free;
end;

procedure TTestMember.Test_Name_TValue;
var
  LObj: TCompositeObject;
  LRec: TCompositeRecord;
begin
  Check(not Assigned(
    Member.Name<Integer>('haha')
  ));

  Check(not Assigned(
    Member.Name<TCompositeRecord>('Habla')
  ));

  Check(not Assigned(
    Member.Name<TCompositeObject>('Habla')
  ));

  LObj := TCompositeObject.Create(123, '123');
  LRec := TCompositeRecord.Create(123, '123');

  CheckEquals(123, Member.Name<TCompositeObject>('FInteger')(LObj).AsInteger);
  CheckEquals('123', Member.Name<TCompositeObject>('FString')(LObj).AsString);
  CheckEquals(123, Member.Name<TCompositeObject>('_Integer')(LObj).AsInteger);
  CheckEquals('123', Member.Name<TCompositeObject>('_String')(LObj).AsString);

  CheckEquals(123, Member.Name<TCompositeRecord>('FInteger')(LRec).AsInteger);
  CheckEquals('123', Member.Name<TCompositeRecord>('FString')(LRec).AsString);

  LObj.Free;
end;

procedure TTestMember.Test_Name_TView;
var
  LObj: TCompositeObject;
  LRec: TCompositeRecord;
  LView: TView;
begin
  Check(not Assigned(
    Member.Name<Integer>(['haha', 'buhu'])
  ));

  Check(not Assigned(
    Member.Name<Integer>([''])
  ));

  Check(not Assigned(
    Member.Name<TCompositeRecord>([''])
  ));

  Check(not Assigned(
    Member.Name<TCompositeRecord>(['FInteger', 'minus'])
  ));

  Check(not Assigned(
    Member.Name<TCompositeObject>([''])
  ));

  Check(not Assigned(
    Member.Name<TCompositeObject>(['FInteger', 'FStringy'])
  ));

  LObj := TCompositeObject.Create(123, '123');
  LRec := TCompositeRecord.Create(123, '123');

  LView := Member.Name<TCompositeObject>(['FInteger', 'FString'])(LObj);
  CheckEquals(123, LView.FInteger);
  CheckEquals('123', LView.FString);

  LView := Member.Name<TCompositeObject>(['_Integer', '_String'])(LObj);
  CheckEquals(123, LView._Integer);
  CheckEquals('123', LView._String);

  LView := Member.Name<TCompositeRecord>(['FInteger', 'FString'])(LRec);
  CheckEquals(123, LView.FInteger);
  CheckEquals('123', LView.FString);

  LObj.Free;
end;

initialization
  TestFramework.RegisterTest(TTestDynamic.Suite);
  TestFramework.RegisterTest(TTestMember.Suite);
end.
