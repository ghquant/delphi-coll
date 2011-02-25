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

unit Tests.LinkedList;
interface
uses SysUtils,
     Tests.Utils,
     TestFramework,
     Generics.Defaults,
     Generics.Collections,
     Collections.Base,
     Collections.Lists,
     Collections.Stacks;

type
  TTestLinkedList = class(TTestCaseEx)
  published
    procedure TestCreationAndDestroy();
    procedure TestCountClearAddInsertRemoveRemoveAt();
    procedure TestContainsIndexOfLastIndexOf();
    procedure TestCopyTo();
    procedure TestIndexer();
    procedure TestEnumerator();
    procedure TestExceptions();
    procedure TestBigCounts();
    procedure TestObjectVariant();
    procedure Test_Extract();
    procedure Test_AddFirst_1();
    procedure Test_AddFirst_Coll();
    procedure Test_AddLast_1();
    procedure Test_AddLast_Coll();
    procedure Test_RemoveFirst();
    procedure Test_RemoveLast();
    procedure Test_ExtractFirst();
    procedure Test_ExtractLast();
    procedure Test_Bug0();
    procedure Test_Bug1();
  end;

implementation

{ TTestQueue }

procedure TTestLinkedList.TestCountClearAddInsertRemoveRemoveAt;
var
  LinkedList  : TLinkedList<String>;
  Stack : TStack<String>;
begin
  LinkedList := TLinkedList<String>.Create();
  Stack := TStack<String>.Create();

  Stack.Push('s1');
  Stack.Push('s2');
  Stack.Push('s3');

  LinkedList.Add('1');
  LinkedList.Add('2');
  LinkedList.Add('3');

  Check((LinkedList.Count = 3) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 3');

  { 1 2 3 }
  LinkedList.Insert(0, '0');

  { 0 1 2 3 }
  LinkedList.Insert(1, '-1');


  { 0 -1 1 2 3 }
  LinkedList.Insert(5, '5');

  Check((LinkedList.Count = 6) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 6');

  LinkedList.Insert(6, Stack);

  Check((LinkedList.Count = 9) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 9');

  Check(LinkedList[6] = 's1', 'LinkedList[6] expected to be "s1"');
  Check(LinkedList[7] = 's2', 'LinkedList[7] expected to be "s2"');
  Check(LinkedList[8] = 's3', 'LinkedList[8] expected to be "s3"');

  LinkedList.Add('Back1');

  Check((LinkedList.Count = 10) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 10');
  Check(LinkedList[9] = 'Back1', 'LinkedList[9] expected to be "Back1"');

  LinkedList.Remove('1');
  LinkedList.Remove('Back1');

  Check((LinkedList.Count = 8) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 8');
  Check(LinkedList[7] = 's3', 'LinkedList[7] expected to be "s3"');
  Check(LinkedList[1] = '-1', 'LinkedList[1] expected to be "-1"');
  Check(LinkedList[2] = '2', 'LinkedList[2] expected to be "2"');

  LinkedList.RemoveAt(0);
  LinkedList.RemoveAt(0);

  Check((LinkedList.Count = 6) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 6');
  Check(LinkedList[0] = '2', 'LinkedList[0] expected to be "2"');
  Check(LinkedList[1] = '3', 'LinkedList[1] expected to be "3"');

  LinkedList.Clear();

  Check((LinkedList.Count = 0) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 0');

  LinkedList.Add('0');
  Check((LinkedList.Count = 1) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 1');

  LinkedList.Remove('0');
  Check((LinkedList.Count = 0) and (LinkedList.Count = LinkedList.GetCount()), 'LinkedList count expected to be 0');

  LinkedList.Free;
  Stack.Free;
end;

procedure TTestLinkedList.TestCopyTo;
var
  LinkedList  : TLinkedList<Integer>;
  IL    : array of Integer;
begin
  LinkedList := TLinkedList<Integer>.Create();

  { Add elements to the LinkedList }
  LinkedList.Add(1);
  LinkedList.Add(2);
  LinkedList.Add(3);
  LinkedList.Add(4);
  LinkedList.Add(5);

  { Check the copy }
  SetLength(IL, 5);
  LinkedList.CopyTo(IL);

  Check(IL[0] = 1, 'Element 0 in the new array is wrong!');
  Check(IL[1] = 2, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 3, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 4, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 5, 'Element 4 in the new array is wrong!');

  { Check the copy with index }
  SetLength(IL, 6);
  LinkedList.CopyTo(IL, 1);

  Check(IL[1] = 1, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 2, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 3, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 4, 'Element 4 in the new array is wrong!');
  Check(IL[5] = 5, 'Element 5 in the new array is wrong!');

  { Exception  }
  SetLength(IL, 4);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin LinkedList.CopyTo(IL); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size).'
  );

  SetLength(IL, 5);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin LinkedList.CopyTo(IL, 1); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size +1).'
  );

  LinkedList.Free();
end;

procedure TTestLinkedList.TestBigCounts;
const
  NrItems = 100000;
var
  LinkedList    : TLinkedList<Integer>;
  I, SumK : Integer;
begin
  LinkedList := TLinkedList<Integer>.Create();

  SumK := 0;

  for I := 0 to NrItems - 1 do
  begin
    LinkedList.Add(I);
    SumK := SumK + I;
  end;

  for I in LinkedList do
  begin
    SumK := SumK + I;
  end;

  while LinkedList.Count > 0 do
  begin
    SumK := SumK - (LinkedList[0] * 2);
    LinkedList.RemoveAt(0);
  end;

  Check(SumK = 0, 'Failed to collect all items in the LinkedList!');
  LinkedList.Free;
end;

procedure TTestLinkedList.TestContainsIndexOfLastIndexOf;
var
  LinkedList  : TLinkedList<Integer>;
begin
  LinkedList := TLinkedList<Integer>.Create();

  LinkedList.Add(1);
  LinkedList.Add(2);
  LinkedList.Add(3);
  LinkedList.Add(4);   {-}
  LinkedList.Add(5);
  LinkedList.Add(6);
  LinkedList.Add(4);   {-}
  LinkedList.Add(7);
  LinkedList.Add(8);
  LinkedList.Add(9);

  Check(LinkedList.Contains(1), 'LinkedList expected to contain 1');
  Check(LinkedList.Contains(2), 'LinkedList expected to contain 2');
  Check(LinkedList.Contains(3), 'LinkedList expected to contain 3');
  Check(LinkedList.Contains(4), 'LinkedList expected to contain 4');
  Check(not LinkedList.Contains(10), 'LinkedList not expected to contain 10');

  Check(LinkedList.IndexOf(1) = 0, 'LinkedList expected to contain 1 at index 0');
  Check(LinkedList.IndexOf(2) = 1, 'LinkedList expected to contain 2 at index 1');
  Check(LinkedList.IndexOf(3) = 2, 'LinkedList expected to contain 3 at index 2');
  Check(LinkedList.IndexOf(4) = 3, 'LinkedList expected to contain 4 at index 3');

  Check(LinkedList.IndexOf(1, 1) = -1, 'LinkedList not expected to find index of 1');
  Check(LinkedList.IndexOf(2, 0) = 1, 'LinkedList expected to contain 2 at index 1');
  Check(LinkedList.IndexOf(4, 0, 2) = -1, 'LinkedList not expected to find index of 4');
  Check(LinkedList.IndexOf(4, 0, 4) = 3, 'LinkedList expected to contain 4 at index 3');
  Check(LinkedList.IndexOf(4, 4) = 6, 'LinkedList expected to contain 4 at index 6');

  Check(LinkedList.LastIndexOf(1) = 0, 'LinkedList expected to contain 1 at index 0');
  Check(LinkedList.LastIndexOf(2) = 1, 'LinkedList expected to contain 2 at index 1');
  Check(LinkedList.LastIndexOf(3) = 2, 'LinkedList expected to contain 3 at index 2');
  Check(LinkedList.LastIndexOf(4) = 6, 'LinkedList expected to contain 4 at index 6');

  Check(LinkedList.LastIndexOf(1, 1) = -1, 'LinkedList not expected to find index of 1');
  Check(LinkedList.LastIndexOf(2, 0) = 1, 'LinkedList expected to contain 2 at index 1');
  Check(LinkedList.LastIndexOf(4, 0, 2) = -1, 'LinkedList not expected to find index of 4');
  Check(LinkedList.LastIndexOf(4, 0, 4) = 3, 'LinkedList expected to contain 4 at index 3');
  Check(LinkedList.LastIndexOf(4, 4) = 6, 'LinkedList expected to contain 4 at index 6');

  LinkedList.Free();
end;

procedure TTestLinkedList.TestCreationAndDestroy;
var
  LinkedList : TLinkedList<Integer>;
  Stack : TStack<Integer>;
  IL    : array of Integer;
begin
  { With default capacity }
  LinkedList := TLinkedList<Integer>.Create();

  LinkedList.Add(10);
  LinkedList.Add(20);
  LinkedList.Add(30);
  LinkedList.Add(40);

  Check(LinkedList.Count = 4, 'LinkedList count expected to be 4)');

  LinkedList.Free();

  { With Copy }
  Stack := TStack<Integer>.Create();
  Stack.Push(1);
  Stack.Push(2);
  Stack.Push(3);
  Stack.Push(4);

  LinkedList := TLinkedList<Integer>.Create(Stack);

  Check(LinkedList.Count = 4, 'LinkedList count expected to be 4)');
  Check(LinkedList[0] = 1, 'LinkedList[0] expected to be 1)');
  Check(LinkedList[1] = 2, 'LinkedList[1] expected to be 2)');
  Check(LinkedList[2] = 3, 'LinkedList[2] expected to be 3)');
  Check(LinkedList[3] = 4, 'LinkedList[3] expected to be 4)');

  LinkedList.Free();
  Stack.Free();

  { Copy from array tests }
  SetLength(IL, 5);

  IL[0] := 1;
  IL[1] := 2;
  IL[2] := 3;
  IL[3] := 4;
  IL[4] := 5;

  LinkedList := TLinkedList<Integer>.Create(IL);

  Check(LinkedList.Count = 5, 'LinkedList count expected to be 5');

  Check(LinkedList[0] = 1, 'LinkedList[0] expected to be 1');
  Check(LinkedList[1] = 2, 'LinkedList[1] expected to be 2');
  Check(LinkedList[2] = 3, 'LinkedList[2] expected to be 3');
  Check(LinkedList[3] = 4, 'LinkedList[3] expected to be 4');
  Check(LinkedList[4] = 5, 'LinkedList[4] expected to be 5');

  LinkedList.Free;
end;

procedure TTestLinkedList.TestEnumerator;
var
  LinkedList : TLinkedList<Integer>;
  I, X  : Integer;
begin
  LinkedList := TLinkedList<Integer>.Create();

  LinkedList.Add(10);
  LinkedList.Add(20);
  LinkedList.Add(30);

  X := 0;

  for I in LinkedList do
  begin
    if X = 0 then
       Check(I = 10, 'Enumerator failed at 0!')
    else if X = 1 then
       Check(I = 20, 'Enumerator failed at 1!')
    else if X = 2 then
       Check(I = 30, 'Enumerator failed at 2!')
    else
       Fail('Enumerator failed!');

    Inc(X);
  end;

  { Test exceptions }


  CheckException(ECollectionChangedException,
    procedure()
    var
      I : Integer;
    begin
      for I in LinkedList do
      begin
        LinkedList.Remove(I);
      end;
    end,
    'ECollectionChangedException not thrown in Enumerator!'
  );

  Check(LinkedList.Count = 2, 'Enumerator failed too late');

  LinkedList.Free();
end;

procedure TTestLinkedList.TestExceptions;
var
  LinkedList, NullLinkedList : TLinkedList<Integer>;
begin
  NullLinkedList := nil;


  CheckException(EArgumentNilException,
    procedure()
    begin
      LinkedList := TLinkedList<Integer>.Create(TRules<Integer>.Default, NullLinkedList);
      LinkedList.Free();
    end,
    'EArgumentNilException not thrown in constructor (nil enum).'
  );

  LinkedList := TLinkedList<Integer>.Create();

  CheckException(EArgumentNilException,
    procedure() begin LinkedList.Add(NullLinkedList); end,
    'EArgumentNilException not thrown in Add (nil enum).'
  );

  CheckException(EArgumentNilException,
    procedure() begin LinkedList.Insert(0, NullLinkedList); end,
    'EArgumentNilException not thrown in Insert (nil enum).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LinkedList.RemoveAt(0); end,
    'EArgumentOutOfRangeException not thrown in RemoveAt (empty).'
  );

  LinkedList.Add(1);

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LinkedList.IndexOf(1, 0, 2); end,
    'EArgumentOutOfRangeException not thrown in IndexOf (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LinkedList.IndexOf(1, 2); end,
    'EArgumentOutOfRangeException not thrown in IndexOf (index out of).'
  );


  CheckException(EArgumentOutOfRangeException,
    procedure() begin LinkedList.LastIndexOf(1, 0, 2); end,
    'EArgumentOutOfRangeException not thrown in LastIndexOf (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LinkedList.LastIndexOf(1, 2); end,
    'EArgumentOutOfRangeException not thrown in LastIndexOf (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LinkedList[1]; end,
    'EArgumentOutOfRangeException not thrown in LinkedList.Items (index out of).'
  );

  LinkedList.Free();
end;

procedure TTestLinkedList.TestIndexer;
var
  LinkedList : TLinkedList<Integer>;
begin
  LinkedList := TLinkedList<Integer>.Create();

  LinkedList.Add(1);
  LinkedList.Add(2);
  LinkedList.Add(3);

  Check(LinkedList[0] = 1, 'LinkedList[0] expected to be 1');
  Check(LinkedList[1] = 2, 'LinkedList[1] expected to be 2');
  Check(LinkedList[2] = 3, 'LinkedList[2] expected to be 3');

  LinkedList.Add(4);
  LinkedList.Add(5);
  LinkedList.Add(6);

  Check(LinkedList[3] = 4, 'LinkedList[3] expected to be 4');
  Check(LinkedList[4] = 5, 'LinkedList[4] expected to be 5');
  Check(LinkedList[5] = 6, 'LinkedList[5] expected to be 6');

  LinkedList[3] := 44;
  LinkedList[0] := 11;

  Check(LinkedList[0] = 11, 'LinkedList[0] expected to be 11');
  Check(LinkedList[1] = 2, 'LinkedList[1] expected to be 2');
  Check(LinkedList[2] = 3, 'LinkedList[2] expected to be 3');
  Check(LinkedList[3] = 44, 'LinkedList[3] expected to be 44');
  Check(LinkedList[4] = 5, 'LinkedList[4] expected to be 5');
  Check(LinkedList[5] = 6, 'LinkedList[5] expected to be 6');

  LinkedList.Free();
end;

procedure TTestLinkedList.TestObjectVariant;
var
  ObjLinkedList: TObjectLinkedList<TTestObject>;
  TheObject: TTestObject;
  ObjectDied: Boolean;
begin
  ObjLinkedList := TObjectLinkedList<TTestObject>.Create();
  CheckFalse(ObjLinkedList.OwnsObjects, 'OwnsObjects must be false!');

  TheObject := TTestObject.Create(@ObjectDied);
  ObjLinkedList.Add(TheObject);
  ObjLinkedList.Clear;
  CheckFalse(ObjectDied, 'The object should not have been cleaned up!');

  ObjLinkedList.Add(TheObject);
  ObjLinkedList.OwnsObjects := true;
  Check(ObjLinkedList.OwnsObjects, 'OwnsObjects must be true!');
  ObjLinkedList.Clear;
  Check(ObjectDied, 'The object should have been cleaned up!');

  ObjLinkedList.Free;
end;

procedure TTestLinkedList.Test_AddFirst_1;
var
  LList: TLinkedList<Integer>;
begin
  LList := TLinkedList<Integer>.Create();
  LList.AddFirst(1);
  LList.AddFirst(2);
  LList.AddFirst(3);

  CheckEquals(3, LList.Count);
  CheckEquals(3, LList[0]);
  CheckEquals(2, LList[1]);
  CheckEquals(1, LList[2]);

  LList.Free;
end;

procedure TTestLinkedList.Test_AddFirst_Coll;
var
  LList, LOther: TLinkedList<Integer>;
begin
  LOther := TLinkedList<Integer>.Create([1, 2, 3]);
  LList := TLinkedList<Integer>.Create();
  LList.AddFirst(LOther);

  CheckEquals(3, LList.Count);
  CheckEquals(1, LList[0]);
  CheckEquals(2, LList[1]);
  CheckEquals(3, LList[2]);

  CheckException(EArgumentNilException,
    procedure() begin LList.AddFirst(nil); end,
    'EArgumentNilException not thrown in AddFirst (nil enum).'
  );

  LList.Free;
  LOther.Free;
end;

procedure TTestLinkedList.Test_AddLast_1;
var
  LList: TLinkedList<Integer>;
begin
  LList := TLinkedList<Integer>.Create();
  LList.AddLast(1);
  LList.AddLast(2);
  LList.AddLast(3);

  CheckEquals(3, LList.Count);
  CheckEquals(1, LList[0]);
  CheckEquals(2, LList[1]);
  CheckEquals(3, LList[2]);

  LList.Free;
end;

procedure TTestLinkedList.Test_AddLast_Coll;
var
  LList, LOther: TLinkedList<Integer>;
begin
  LOther := TLinkedList<Integer>.Create([1, 2, 3]);
  LList := TLinkedList<Integer>.Create();
  LList.AddLast(LOther);

  CheckEquals(3, LList.Count);
  CheckEquals(1, LList[0]);
  CheckEquals(2, LList[1]);
  CheckEquals(3, LList[2]);

  CheckException(EArgumentNilException,
    procedure() begin LList.AddLast(nil); end,
    'EArgumentNilException not thrown in AddLast (nil enum).'
  );

  LList.Free;
  LOther.Free;
end;

procedure TTestLinkedList.Test_Bug0;
var
  LList: TLinkedList<Integer>;
begin
  LList := TLinkedList<Integer>.Create();

  CheckEquals(false, LList.Contains(1));
  CheckEquals(-1, LList.IndexOf(1));
  CheckEquals(-1, LList.IndexOf(1, 0));
  CheckEquals(-1, LList.IndexOf(1, 0, 0));

  CheckEquals(-1, LList.LastIndexOf(1));
  CheckEquals(-1, LList.LastIndexOf(1, 0));
  CheckEquals(-1, LList.LastIndexOf(1, 0, 0));

  LList.Free;
end;

procedure TTestLinkedList.Test_Bug1;
var
  LList: TObjectLinkedList<TTestObject>;
  LValue: TTestObject;
  LValueDied: Boolean;
begin
  { Prepare }
  LList := TObjectLinkedList<TTestObject>.Create();
  LValue := TTestObject.Create(@LValueDied);
  LValueDied := false;

  LList.Add(LValue);

  LList[0] := nil;
  CheckFalse(LValueDied);

  { ---- }

  LList[0] := LValue;
  LList.OwnsObjects := true;

  LList[0] := LValue;
  CheckFalse(LValueDied);

  LList[0] := nil;
  CheckTrue(LValueDied);

  LList.Free;
end;

procedure TTestLinkedList.Test_Extract;
var
  LList: TObjectLinkedList<TTestObject>;
  LValue: TTestObject;
  LValueDied: Boolean;
begin
  { Prepare }
  LList := TObjectLinkedList<TTestObject>.Create();
  LValue := TTestObject.Create(@LValueDied);
  LValueDied := false;

  LList.Add(LValue);
  CheckTrue(LList.ExtractAt(0) = LValue);
  CheckFalse(LValueDied);

  { ---- }

  LList.OwnsObjects := true;
  LList.Add(LValue);
  CheckTrue(LList.ExtractAt(0) = LValue);
  CheckFalse(LValueDied);

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LList.ExtractAt(0); end,
    'EArgumentOutOfRangeException not thrown in ExtractAt (0).'
  );

  LList.Add(LValue);

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LList.ExtractAt(1); end,
    'EArgumentOutOfRangeException not thrown in ExtractAt (1).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LList.ExtractAt(-1); end,
    'EArgumentOutOfRangeException not thrown in ExtractAt (-1).'
  );

  LList.RemoveAt(0);
  CheckTrue(LValueDied);

  LList.Free;
end;

procedure TTestLinkedList.Test_ExtractFirst;
var
  LList: TObjectLinkedList<TTestObject>;
  L1, L2: TTestObject;
  LValueDied: Boolean;
begin
  { Prepare }
  LList := TObjectLinkedList<TTestObject>.Create();
  L1 := TTestObject.Create(@LValueDied);
  L2 := TTestObject.Create(@LValueDied);
  LValueDied := false;

  LList.Add(L1);
  LList.Add(L2);

  CheckTrue(L1 = LList.ExtractFirst());
  CheckFalse(LValueDied);
  CheckTrue(L2 = LList[0]);
  L1.Free;
  LValueDied := False;

  { -- }
  LList.OwnsObjects := True;
  CheckTrue(L2 = LList.ExtractFirst());
  CheckFalse(LValueDied);
  L2.Free;

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LList.ExtractFirst(); end,
    'EArgumentOutOfRangeException not thrown in ExtractFirst (0 remaining).'
  );

  LList.Free;
end;

procedure TTestLinkedList.Test_ExtractLast;
var
  LList: TObjectLinkedList<TTestObject>;
  L1, L2: TTestObject;
  LValueDied: Boolean;
begin
  { Prepare }
  LList := TObjectLinkedList<TTestObject>.Create();
  L1 := TTestObject.Create(@LValueDied);
  L2 := TTestObject.Create(@LValueDied);
  LValueDied := false;

  LList.Add(L1);
  LList.Add(L2);

  CheckTrue(L2 = LList.ExtractLast());
  CheckFalse(LValueDied);
  CheckTrue(L1 = LList[0]);
  L2.Free;
  LValueDied := False;

  { -- }
  LList.OwnsObjects := True;
  CheckTrue(L1 = LList.ExtractLast());
  CheckFalse(LValueDied);
  L1.Free;

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LList.ExtractLast(); end,
    'EArgumentOutOfRangeException not thrown in ExtractLast (0 remaining).'
  );

  LList.Free;
end;

procedure TTestLinkedList.Test_RemoveFirst;
var
  LList: TObjectLinkedList<TTestObject>;
  L1, L2: TTestObject;
  LValueDied: Boolean;
begin
  { Prepare }
  LList := TObjectLinkedList<TTestObject>.Create();
  L1 := TTestObject.Create(@LValueDied);
  L2 := TTestObject.Create(@LValueDied);
  LValueDied := false;

  LList.Add(L1);
  LList.Add(L2);

  LList.RemoveFirst();
  CheckFalse(LValueDied);
  CheckTrue(L2 = LList[0]);
  L1.Free;
  LValueDied := False;

  { -- }
  LList.OwnsObjects := True;
  LList.RemoveFirst();
  CheckTrue(LValueDied);

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LList.RemoveFirst(); end,
    'EArgumentOutOfRangeException not thrown in RemoveFirst (0 remaining).'
  );

  LList.Free;
end;

procedure TTestLinkedList.Test_RemoveLast;
var
  LList: TObjectLinkedList<TTestObject>;
  L1, L2: TTestObject;
  LValueDied: Boolean;
begin
  { Prepare }
  LList := TObjectLinkedList<TTestObject>.Create();
  L1 := TTestObject.Create(@LValueDied);
  L2 := TTestObject.Create(@LValueDied);
  LValueDied := false;

  LList.Add(L1);
  LList.Add(L2);

  LList.RemoveLast();
  CheckFalse(LValueDied);
  CheckTrue(L1 = LList[0]);
  L2.Free;
  LValueDied := False;

  { -- }
  LList.OwnsObjects := True;
  LList.RemoveLast();
  CheckTrue(LValueDied);

  CheckException(EArgumentOutOfRangeException,
    procedure() begin LList.RemoveLast(); end,
    'EArgumentOutOfRangeException not thrown in RemoveFirst (0 remaining).'
  );

  LList.Free;
end;

initialization
  TestFramework.RegisterTest(TTestLinkedList.Suite);

end.
