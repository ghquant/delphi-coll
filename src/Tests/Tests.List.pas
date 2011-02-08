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

unit Tests.List;
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
  TTestList = class(TTestCaseEx)
  published
    procedure TestCreationAndDestroy();
    procedure TestCountClearAddInsertRemoveRemoveAt();
    procedure TestReverse();
    procedure TestSort_Type();
    procedure TestSort_Comp();
    procedure TestContainsIndexOfLastIndexOf();
    procedure TestCopyTo();
    procedure TestCopy();
    procedure TestIndexer();
    procedure TestIDynamic();
    procedure TestEnumerator();
    procedure TestExceptions();
    procedure TestBigCounts();
    procedure TestObjectVariant();
    procedure Test_Extract();

    procedure Test_Bug0();
    procedure Test_Bug1();
  end;

implementation

{ TTestQueue }

procedure TTestList.TestCountClearAddInsertRemoveRemoveAt;
var
  List  : TList<String>;
  Stack : TStack<String>;
begin
  List := TList<String>.Create(0);
  Stack := TStack<String>.Create();

  Stack.Push('s1');
  Stack.Push('s2');
  Stack.Push('s3');

  List.Add('1');
  List.Add('2');
  List.Add('3');

  Check((List.Count = 3) and (List.Count = List.GetCount()), 'List count expected to be 3');

  { 1 2 3 }
  List.Insert(0, '0');

  { 0 1 2 3 }
  List.Insert(1, '-1');


  { 0 -1 1 2 3 }
  List.Insert(5, '5');

  Check((List.Count = 6) and (List.Count = List.GetCount()), 'List count expected to be 6');

  List.Insert(6, Stack);

  Check((List.Count = 9) and (List.Count = List.GetCount()), 'List count expected to be 9');

  Check(List[6] = 's1', 'List[6] expected to be "s1"');
  Check(List[7] = 's2', 'List[7] expected to be "s2"');
  Check(List[8] = 's3', 'List[8] expected to be "s3"');

  List.Add('Back1');

  Check((List.Count = 10) and (List.Count = List.GetCount()), 'List count expected to be 10');
  Check(List[9] = 'Back1', 'List[9] expected to be "Back1"');

  List.Remove('1');
  List.Remove('Back1');

  Check((List.Count = 8) and (List.Count = List.GetCount()), 'List count expected to be 8');
  Check(List[7] = 's3', 'List[7] expected to be "s3"');
  Check(List[1] = '-1', 'List[1] expected to be "-1"');
  Check(List[2] = '2', 'List[2] expected to be "2"');

  List.RemoveAt(0);
  List.RemoveAt(0);

  Check((List.Count = 6) and (List.Count = List.GetCount()), 'List count expected to be 6');
  Check(List[0] = '2', 'List[0] expected to be "2"');
  Check(List[1] = '3', 'List[1] expected to be "3"');

  List.Clear();

  Check((List.Count = 0) and (List.Count = List.GetCount()), 'List count expected to be 0');

  List.Add('0');
  Check((List.Count = 1) and (List.Count = List.GetCount()), 'List count expected to be 1');

  List.Remove('0');
  Check((List.Count = 0) and (List.Count = List.GetCount()), 'List count expected to be 0');

  List.Free;
  Stack.Free;
end;

procedure TTestList.TestCopy;
var
  List1, List2 : TList<Integer>;
begin
  List1 := TList<Integer>.Create();

  List1.Add(1);
  List1.Add(2);
  List1.Add(3);
  List1.Add(4);

  List2 := List1.Copy(1, 3);

  Check(List2.Count = 3, 'List2 count expected to be 3');
  Check(List2[0] = 2, 'List2[0] expected to be 2');
  Check(List2[1] = 3, 'List2[1] expected to be 3');
  Check(List2[2] = 4, 'List2[2] expected to be 4');

  List2.Free();

  { -- }

  List2 := List1.Copy(0, 1);

  Check(List2.Count = 1, 'List2 count expected to be 1');
  Check(List2[0] = 1, 'List2[0] expected to be 1');

  List2.Free();

  { -- }

  List2 := List1.Copy(2);

  Check(List2.Count = 2, 'List2 count expected to be 2');
  Check(List2[0] = 3, 'List2[0] expected to be 3');
  Check(List2[1] = 4, 'List2[1] expected to be 4');

  List2.Free();

  { -- }

  List2 := List1.Copy();

  Check(List2.Count = 4, 'List2 count expected to be 2');
  Check(List2[0] = 1, 'List2[0] expected to be 1');
  Check(List2[1] = 2, 'List2[1] expected to be 2');
  Check(List2[2] = 3, 'List2[2] expected to be 3');
  Check(List2[3] = 4, 'List2[3] expected to be 4');

  List2.Free();
  List1.Free();
end;

procedure TTestList.TestCopyTo;
var
  List  : TList<Integer>;
  IL    : array of Integer;
begin
  List := TList<Integer>.Create();

  { Add elements to the list }
  List.Add(1);
  List.Add(2);
  List.Add(3);
  List.Add(4);
  List.Add(5);

  { Check the copy }
  SetLength(IL, 5);
  List.CopyTo(IL);

  Check(IL[0] = 1, 'Element 0 in the new array is wrong!');
  Check(IL[1] = 2, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 3, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 4, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 5, 'Element 4 in the new array is wrong!');

  { Check the copy with index }
  SetLength(IL, 6);
  List.CopyTo(IL, 1);

  Check(IL[1] = 1, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 2, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 3, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 4, 'Element 4 in the new array is wrong!');
  Check(IL[5] = 5, 'Element 5 in the new array is wrong!');

  { Exception  }
  SetLength(IL, 4);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin List.CopyTo(IL); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size).'
  );

  SetLength(IL, 5);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin List.CopyTo(IL, 1); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size +1).'
  );

  List.Free();
end;

procedure TTestList.TestBigCounts;
const
  NrItems = 100000;
var
  List    : TList<Integer>;
  I, SumK : Integer;
begin
  List := TList<Integer>.Create();

  SumK := 0;

  for I := 0 to NrItems - 1 do
  begin
    List.Add(I);
    SumK := SumK + I;
  end;

  for I := 0 to List.Count - 1 do
  begin
    SumK := SumK + List[I];
  end;

  while List.Count > 0 do
  begin
    SumK := SumK - (List[List.Count - 1] * 2);
    List.RemoveAt(List.Count - 1);
  end;

  Check(SumK = 0, 'Failed to collect all items in the list!');
  List.Free;
end;

procedure TTestList.TestContainsIndexOfLastIndexOf;
var
  List  : TList<Integer>;
begin
  List := TList<Integer>.Create();

  List.Add(1);
  List.Add(2);
  List.Add(3);
  List.Add(4);   {-}
  List.Add(5);
  List.Add(6);
  List.Add(4);   {-}
  List.Add(7);
  List.Add(8);
  List.Add(9);

  Check(List.Contains(1), 'List expected to contain 1');
  Check(List.Contains(2), 'List expected to contain 2');
  Check(List.Contains(3), 'List expected to contain 3');
  Check(List.Contains(4), 'List expected to contain 4');
  Check(not List.Contains(10), 'List not expected to contain 10');

  Check(List.IndexOf(1) = 0, 'List expected to contain 1 at index 0');
  Check(List.IndexOf(2) = 1, 'List expected to contain 2 at index 1');
  Check(List.IndexOf(3) = 2, 'List expected to contain 3 at index 2');
  Check(List.IndexOf(4) = 3, 'List expected to contain 4 at index 3');

  Check(List.IndexOf(1, 1) = -1, 'List not expected to find index of 1');
  Check(List.IndexOf(2, 0) = 1, 'List expected to contain 2 at index 1');
  Check(List.IndexOf(4, 0, 2) = -1, 'List not expected to find index of 4');
  Check(List.IndexOf(4, 0, 4) = 3, 'List expected to contain 4 at index 3');
  Check(List.IndexOf(4, 4) = 6, 'List expected to contain 4 at index 6');

  Check(List.LastIndexOf(1) = 0, 'List expected to contain 1 at index 0');
  Check(List.LastIndexOf(2) = 1, 'List expected to contain 2 at index 1');
  Check(List.LastIndexOf(3) = 2, 'List expected to contain 3 at index 2');
  Check(List.LastIndexOf(4) = 6, 'List expected to contain 4 at index 6');

  Check(List.LastIndexOf(1, 1) = -1, 'List not expected to find index of 1');
  Check(List.LastIndexOf(2, 0) = 1, 'List expected to contain 2 at index 1');
  Check(List.LastIndexOf(4, 0, 2) = -1, 'List not expected to find index of 4');
  Check(List.LastIndexOf(4, 0, 4) = 3, 'List expected to contain 4 at index 3');
  Check(List.LastIndexOf(4, 4) = 6, 'List expected to contain 4 at index 6');

  List.Free();
end;

procedure TTestList.TestCreationAndDestroy;
var
  List : TList<Integer>;
  Stack : TStack<Integer>;
  IL    : array of Integer;
begin
  { With default capacity }
  List := TList<Integer>.Create();

  List.Add(10);
  List.Add(20);
  List.Add(30);
  List.Add(40);

  Check(List.Count = 4, 'List count expected to be 4)');

  List.Free();

  { With preset capacity }
  List := TList<Integer>.Create(0);

  List.Add(10);
  List.Add(20);
  List.Add(30);
  List.Add(40);

  Check(List.Count = 4, 'List count expected to be 4)');

  List.Free();

  { With Copy }
  Stack := TStack<Integer>.Create();
  Stack.Push(1);
  Stack.Push(2);
  Stack.Push(3);
  Stack.Push(4);

  List := TList<Integer>.Create(Stack);

  Check(List.Count = 4, 'List count expected to be 4)');
  Check(List[0] = 1, 'List[0] expected to be 1)');
  Check(List[1] = 2, 'List[1] expected to be 2)');
  Check(List[2] = 3, 'List[2] expected to be 3)');
  Check(List[3] = 4, 'List[3] expected to be 4)');

  List.Free();
  Stack.Free();

  { Copy from array tests }
  SetLength(IL, 5);

  IL[0] := 1;
  IL[1] := 2;
  IL[2] := 3;
  IL[3] := 4;
  IL[4] := 5;

  List := TList<Integer>.Create(IL);

  Check(List.Count = 5, 'List count expected to be 5');

  Check(List[0] = 1, 'List[0] expected to be 1');
  Check(List[1] = 2, 'List[1] expected to be 2');
  Check(List[2] = 3, 'List[2] expected to be 3');
  Check(List[3] = 4, 'List[3] expected to be 4');
  Check(List[4] = 5, 'List[4] expected to be 5');

  List.Free;
end;

procedure TTestList.TestEnumerator;
var
  List : TList<Integer>;
  I, X  : Integer;
begin
  List := TList<Integer>.Create();

  List.Add(10);
  List.Add(20);
  List.Add(30);

  X := 0;

  for I in List do
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
      for I in List do
      begin
        List.Remove(I);
      end;
    end,
    'ECollectionChangedException not thrown in Enumerator!'
  );

  Check(List.Count = 2, 'Enumerator failed too late');

  List.Free();
end;

procedure TTestList.TestExceptions;
var
  List, NullList : TList<Integer>;
begin
  NullList := nil;


  CheckException(EArgumentNilException,
    procedure()
    begin
      List := TList<Integer>.Create(TRules<Integer>.Default, NullList);
      List.Free();
    end,
    'EArgumentNilException not thrown in constructor (nil enum).'
  );

  List := TList<Integer>.Create();

  CheckException(EArgumentNilException,
    procedure() begin List.Add(NullList); end,
    'EArgumentNilException not thrown in Add (nil enum).'
  );

  CheckException(EArgumentNilException,
    procedure() begin List.Insert(0, NullList); end,
    'EArgumentNilException not thrown in Insert (nil enum).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.RemoveAt(0); end,
    'EArgumentOutOfRangeException not thrown in RemoveAt (empty).'
  );

  List.Add(1);

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.Reverse(0, 2); end,
    'EArgumentOutOfRangeException not thrown in Reverse (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.Reverse(2); end,
    'EArgumentOutOfRangeException not thrown in Reverse (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.Sort(0, 2); end,
    'EArgumentOutOfRangeException not thrown in Sort (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.Sort(2); end,
    'EArgumentOutOfRangeException not thrown in Sort (index out of).'
  );


  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.IndexOf(1, 0, 2); end,
    'EArgumentOutOfRangeException not thrown in IndexOf (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.IndexOf(1, 2); end,
    'EArgumentOutOfRangeException not thrown in IndexOf (index out of).'
  );


  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.LastIndexOf(1, 0, 2); end,
    'EArgumentOutOfRangeException not thrown in LastIndexOf (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.LastIndexOf(1, 2); end,
    'EArgumentOutOfRangeException not thrown in LastIndexOf (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.Copy(0, 2); end,
    'EArgumentOutOfRangeException not thrown in Copy (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List.Copy(2); end,
    'EArgumentOutOfRangeException not thrown in Copy (index out of).'
  );

  CheckException(EArgumentOutOfRangeException,
    procedure() begin List[1]; end,
    'EArgumentOutOfRangeException not thrown in List.Items (index out of).'
  );

  List.Free();
end;

procedure TTestList.TestIDynamic;
const
  NrElem = 1000;

var
  AList: TList<Integer>;
  I: Integer;
begin
  { With intitial capacity }
  AList := TList<Integer>.Create(100);

  AList.Shrink();
  Check(AList.Capacity = 0, 'Capacity expected to be 0');
  Check(AList.GetCapacity() = AList.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AList.Grow();
  Check(AList.Capacity > 0, 'Capacity expected to be > 0');
  Check(AList.GetCapacity() = AList.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AList.Shrink();
  AList.Add(10);
  AList.Add(20);
  AList.Add(30);
  Check(AList.Capacity > AList.Count, 'Capacity expected to be > Count');
  Check(AList.GetCapacity() = AList.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AList.Shrink();
  Check(AList.Capacity = AList.Count, 'Capacity expected to be = Count');
  Check(AList.GetCapacity() = AList.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AList.Grow();
  Check(AList.Capacity > AList.Count, 'Capacity expected to be > Count');
  Check(AList.GetCapacity() = AList.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AList.Clear();
  AList.Shrink();
  Check(AList.Capacity = 0, 'Capacity expected to be = 0');
  Check(AList.GetCapacity() = AList.Capacity, 'GetCapacity() expected to be equal to Capacity');


  for I := 0 to NrElem - 1 do
    AList.Add(I);

  for I := 0 to NrElem - 1 do
    AList.Remove(I);

  Check(AList.Capacity > NrElem, 'Capacity expected to be > NrElem');
  Check(AList.GetCapacity() = AList.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AList.Free;
end;

procedure TTestList.TestIndexer;
var
  List : TList<Integer>;
begin
  List := TList<Integer>.Create();

  List.Add(1);
  List.Add(2);
  List.Add(3);

  Check(List[0] = 1, 'List[0] expected to be 1');
  Check(List[1] = 2, 'List[1] expected to be 2');
  Check(List[2] = 3, 'List[2] expected to be 3');

  List.Add(4);
  List.Add(5);
  List.Add(6);

  Check(List[3] = 4, 'List[3] expected to be 4');
  Check(List[4] = 5, 'List[4] expected to be 5');
  Check(List[5] = 6, 'List[5] expected to be 6');

  List[3] := 44;
  List[0] := 11;

  Check(List[0] = 11, 'List[0] expected to be 11');
  Check(List[1] = 2, 'List[1] expected to be 2');
  Check(List[2] = 3, 'List[2] expected to be 3');
  Check(List[3] = 44, 'List[3] expected to be 44');
  Check(List[4] = 5, 'List[4] expected to be 5');
  Check(List[5] = 6, 'List[5] expected to be 6');

  List.Free();
end;

procedure TTestList.TestObjectVariant;
var
  ObjList: TObjectList<TTestObject>;
  TheObject: TTestObject;
  ObjectDied: Boolean;
begin
  ObjList := TObjectList<TTestObject>.Create();
  CheckFalse(ObjList.OwnsObjects, 'OwnsObjects must be false!');

  TheObject := TTestObject.Create(@ObjectDied);
  ObjList.Add(TheObject);
  ObjList.Clear;
  CheckFalse(ObjectDied, 'The object should not have been cleaned up!');

  ObjList.Add(TheObject);
  ObjList.OwnsObjects := true;
  Check(ObjList.OwnsObjects, 'OwnsObjects must be true!');
  ObjList.Clear;
  Check(ObjectDied, 'The object should have been cleaned up!');

  ObjList.Free;
end;

procedure TTestList.TestReverse;
var
  List : TList<Integer>;
begin
  List := TList<Integer>.Create();

  List.Add(1);
  List.Add(2);
  List.Add(3);
  List.Add(4);
  List.Add(5);

  List.Reverse(0, 1);

  Check(List[0] = 1, 'List[0] expected to be 1');
  Check(List[1] = 2, 'List[1] expected to be 2');
  Check(List[2] = 3, 'List[2] expected to be 3');
  Check(List[3] = 4, 'List[3] expected to be 4');
  Check(List[4] = 5, 'List[4] expected to be 5');

  List.Reverse(0, 2);

  Check(List[0] = 2, 'List[0] expected to be 2');
  Check(List[1] = 1, 'List[1] expected to be 1');
  Check(List[2] = 3, 'List[2] expected to be 3');
  Check(List[3] = 4, 'List[3] expected to be 4');
  Check(List[4] = 5, 'List[4] expected to be 5');

  List.Reverse(2);

  Check(List[0] = 2, 'List[0] expected to be 2');
  Check(List[1] = 1, 'List[1] expected to be 1');
  Check(List[2] = 5, 'List[2] expected to be 5');
  Check(List[3] = 4, 'List[3] expected to be 4');
  Check(List[4] = 3, 'List[4] expected to be 3');

  List.Reverse();

  Check(List[0] = 3, 'List[0] expected to be 3');
  Check(List[1] = 4, 'List[1] expected to be 4');
  Check(List[2] = 5, 'List[2] expected to be 5');
  Check(List[3] = 1, 'List[3] expected to be 1');
  Check(List[4] = 2, 'List[4] expected to be 2');

  List.Free();
end;

procedure TTestList.TestSort_Comp;
var
  List : TList<String>;
  AComp: TComparison<String>;
begin
  AComp := function(const ALeft, ARight: String): Integer
  begin
    Result := StrToInt(ALeft) - StrToInt(ARight);
  end;

  List := TList<String>.Create();

  List.Add('1');
  List.Add('5');
  List.Add('4');
  List.Add('2');
  List.Add('3');

  List.Sort(0, 1);

  Check(List[0] = '1', 'List[0] expected to be 1');
  Check(List[1] = '5', 'List[1] expected to be 5');
  Check(List[2] = '4', 'List[2] expected to be 4');
  Check(List[3] = '2', 'List[3] expected to be 2');
  Check(List[4] = '3', 'List[4] expected to be 3');

  List.Sort(0, 3);

  Check(List[0] = '1', 'List[0] expected to be 1');
  Check(List[1] = '4', 'List[1] expected to be 4');
  Check(List[2] = '5', 'List[2] expected to be 5');
  Check(List[3] = '2', 'List[3] expected to be 2');
  Check(List[4] = '3', 'List[4] expected to be 3');

  List.Sort();

  Check(List[0] = '1', 'List[0] expected to be 1');
  Check(List[1] = '2', 'List[1] expected to be 2');
  Check(List[2] = '3', 'List[2] expected to be 3');
  Check(List[3] = '4', 'List[3] expected to be 4');
  Check(List[4] = '5', 'List[4] expected to be 5');

  List.Free();
end;

procedure TTestList.TestSort_Type;
var
  List : TList<Integer>;
begin
  List := TList<Integer>.Create();

  List.Add(1);
  List.Add(5);
  List.Add(4);
  List.Add(2);
  List.Add(3);

  List.Sort(0, 1);

  Check(List[0] = 1, 'List[0] expected to be 1');
  Check(List[1] = 5, 'List[1] expected to be 5');
  Check(List[2] = 4, 'List[2] expected to be 4');
  Check(List[3] = 2, 'List[3] expected to be 2');
  Check(List[4] = 3, 'List[4] expected to be 3');

  List.Sort(0, 3);

  Check(List[0] = 1, 'List[0] expected to be 1');
  Check(List[1] = 4, 'List[1] expected to be 4');
  Check(List[2] = 5, 'List[2] expected to be 5');
  Check(List[3] = 2, 'List[3] expected to be 2');
  Check(List[4] = 3, 'List[4] expected to be 3');

  List.Sort();

  Check(List[0] = 1, 'List[0] expected to be 1');
  Check(List[1] = 2, 'List[1] expected to be 2');
  Check(List[2] = 3, 'List[2] expected to be 3');
  Check(List[3] = 4, 'List[3] expected to be 4');
  Check(List[4] = 5, 'List[4] expected to be 5');

  List.Sort(false);

  Check(List[0] = 5, 'List[0] expected to be 1');
  Check(List[1] = 4, 'List[1] expected to be 2');
  Check(List[2] = 3, 'List[2] expected to be 3');
  Check(List[3] = 2, 'List[3] expected to be 4');
  Check(List[4] = 1, 'List[4] expected to be 5');

  List.Free();
end;

procedure TTestList.Test_Bug0;
var
  LList: TList<Integer>;
begin
  LList := TList<Integer>.Create();

  CheckEquals(false, LList.Contains(1));
  CheckEquals(-1, LList.IndexOf(1));
  CheckEquals(-1, LList.IndexOf(1, 0));
  CheckEquals(-1, LList.IndexOf(1, 0, 0));

  CheckEquals(-1, LList.LastIndexOf(1));
  CheckEquals(-1, LList.LastIndexOf(1, 0));
  CheckEquals(-1, LList.LastIndexOf(1, 0, 0));

  LList.Free;
end;

procedure TTestList.Test_Bug1;
var
  LList: TObjectList<TTestObject>;
  LValue: TTestObject;
  LValueDied: Boolean;
begin
  { Prepare }
  LList := TObjectList<TTestObject>.Create();
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

procedure TTestList.Test_Extract;
var
  LList: TObjectList<TTestObject>;
  LValue: TTestObject;
  LValueDied: Boolean;
begin
  { Prepare }
  LList := TObjectList<TTestObject>.Create();
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

initialization
  TestFramework.RegisterTest(TTestList.Suite);

end.
