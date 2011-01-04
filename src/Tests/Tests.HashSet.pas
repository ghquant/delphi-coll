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

unit Tests.HashSet;
interface
uses SysUtils,
     Tests.Utils,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Stacks,
     Collections.Sets;

type
  TTestHashSet = class(TTestCaseEx)
  published
    procedure TestCreationAndDestroy();
    procedure TestCountClearAdd();
    procedure TestContains();
    procedure TestCopyTo();
    procedure TestEnumerator();
    procedure TestHardCore();
    procedure TestObjectVariant();
  end;

implementation

{ TTestQueue }

procedure TTestHashSet.TestCountClearAdd;
var
  HashSet  : THashSet<String>;
  Stack : TStack<String>;
begin
  HashSet := THashSet<String>.Create(0);
  Stack := TStack<String>.Create();

  Stack.Push('s1');
  Stack.Push('s2');
  Stack.Push('s3');

  HashSet.Add('1');
  HashSet.Add('2');
  HashSet.Add('3');

  Check((HashSet.Count = 3) and (HashSet.Count = HashSet.GetCount()), 'HashSet count expected to be 3');

  { 1 2 3 }
  HashSet.Add('0');

  { 1 2 3 0 }
  HashSet.Add('-1');

  { 1 2 3 0 -1 }
  HashSet.Add('5');

  Check((HashSet.Count = 6) and (HashSet.Count = HashSet.GetCount()), 'HashSet count expected to be 6');


  HashSet.Remove('1');

  Check((HashSet.Count = 5) and (HashSet.Count = HashSet.GetCount()), 'HashSet count expected to be 5');

  HashSet.Remove('5');
  HashSet.Remove('3');
  HashSet.Remove('2');
  HashSet.Remove('-1');
  HashSet.Remove('0');

  Check((HashSet.Count = 0) and (HashSet.Count = HashSet.GetCount()), 'HashSet count expected to be 0');

  HashSet.Free;
  Stack.Free;

end;

procedure TTestHashSet.TestCopyTo;
var
  HashSet  : THashSet<Integer>;
  IL    : array of Integer;
begin
  HashSet := THashSet<Integer>.Create();

  { Add elements to the HashSet }
  HashSet.Add(1);
  HashSet.Add(2);
  HashSet.Add(3);
  HashSet.Add(4);
  HashSet.Add(5);

  { Check the copy }
  SetLength(IL, 5);
  HashSet.CopyTo(IL);

  Check(IL[0] = 1, 'Element 0 in the new array is wrong!');
  Check(IL[1] = 2, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 3, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 4, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 5, 'Element 4 in the new array is wrong!');

  { Check the copy with index }
  SetLength(IL, 6);
  HashSet.CopyTo(IL, 1);

  Check(IL[1] = 1, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 2, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 3, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 4, 'Element 4 in the new array is wrong!');
  Check(IL[5] = 5, 'Element 5 in the new array is wrong!');

  { Exception  }
  SetLength(IL, 4);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin HashSet.CopyTo(IL); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size).'
  );

  SetLength(IL, 5);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin HashSet.CopyTo(IL, 1); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size +1).'
  );

  HashSet.Free();
end;

procedure TTestHashSet.TestContains;
var
  HashSet  : THashSet<Integer>;
begin
  HashSet := THashSet<Integer>.Create();

  HashSet.Add(1);
  HashSet.Add(2);
  HashSet.Add(3);
  HashSet.Add(4);   {-}
  HashSet.Add(5);
  HashSet.Add(6);
  HashSet.Add(4);   {-}
  HashSet.Add(7);
  HashSet.Add(8);
  HashSet.Add(9);

  Check(HashSet.Contains(1), 'Set expected to contain 1');
  Check(HashSet.Contains(2), 'Set expected to contain 2');
  Check(HashSet.Contains(3), 'Set expected to contain 3');
  Check(HashSet.Contains(4), 'Set expected to contain 4');
  Check(not HashSet.Contains(10), 'Set not expected to contain 10');

  HashSet.Free();
end;

procedure TTestHashSet.TestCreationAndDestroy;
var
  HashSet : THashSet<Integer>;
  Stack : TStack<Integer>;
  IL    : array of Integer;
begin
  { With default capacity }
  HashSet := THashSet<Integer>.Create();

  HashSet.Add(10);
  HashSet.Add(20);
  HashSet.Add(30);
  HashSet.Add(40);

  Check(HashSet.Count = 4, 'HashSet count expected to be 4)');

  HashSet.Free();

  { With preset capacity }
  HashSet := THashSet<Integer>.Create(0);

  HashSet.Add(10);
  HashSet.Add(20);
  HashSet.Add(30);
  HashSet.Add(40);

  Check(HashSet.Count = 4, 'HashSet count expected to be 4)');

  HashSet.Free();

  { With Copy }
  Stack := TStack<Integer>.Create();
  Stack.Push(1);
  Stack.Push(2);
  Stack.Push(3);
  Stack.Push(4);

  HashSet := THashSet<Integer>.Create(Stack);

  Check(HashSet.Count = 4, 'HashSet count expected to be 4)');
  Check(HashSet.Contains(1), 'HashSet[1] expected to exist)');
  Check(HashSet.Contains(2), 'HashSet[2] expected to exist)');
  Check(HashSet.Contains(3), 'HashSet[3] expected to exist)');
  Check(HashSet.Contains(4), 'HashSet[4] expected to exist)');

  HashSet.Free();
  Stack.Free();

  { Copy from array tests }
  SetLength(IL, 6);

  IL[0] := 1;
  IL[1] := 2;
  IL[2] := 3;
  IL[3] := 4;
  IL[4] := 5;
  IL[5] := 5;

  HashSet := THashSet<Integer>.Create(IL);

  Check(HashSet.Count = 5, 'HashSet count expected to be 5');

  Check(HashSet.Contains(1), 'HashSet expected to contain 1');
  Check(HashSet.Contains(2), 'HashSet expected to contain 2');
  Check(HashSet.Contains(3), 'HashSet expected to contain 3');
  Check(HashSet.Contains(4), 'HashSet expected to contain 4');
  Check(HashSet.Contains(5), 'HashSet expected to contain 5');

  HashSet.Free;
end;

procedure TTestHashSet.TestEnumerator;
var
  HashSet : THashSet<Integer>;
  I, X  : Integer;
begin
  HashSet := THashSet<Integer>.Create();

  HashSet.Add(10);
  HashSet.Add(20);
  HashSet.Add(30);

  X := 0;

  for I in HashSet do
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
      for I in HashSet do
      begin
        HashSet.Remove(I);
      end;
    end,
    'ECollectionChangedException not thrown in Enumerator!'
  );

  Check(HashSet.Count = 2, 'Enumerator failed too late');

  HashSet.Free();
end;

procedure TTestHashSet.TestHardCore;
const
  NrCont = 10000;

var
  ASet: ISet<Integer>;
  I: Integer;

begin
  ASet := THashSet<Integer>.Create();

  for I := 0 to NrCont - 1 do
    ASet.Add(I);

  for I := 0 to NrCont - 1 do
    ASet.Remove(I);

  Check(ASet.Count = 0, 'Expected an empty set!');
end;

procedure TTestHashSet.TestObjectVariant;
var
  ObjSet: TObjectHashSet<TTestObject>;
  TheObject: TTestObject;
  ObjectDied: Boolean;
begin
  ObjSet := TObjectHashSet<TTestObject>.Create();
  Check(not ObjSet.OwnsObjects, 'OwnsObjects must be false!');

  TheObject := TTestObject.Create(@ObjectDied);
  ObjSet.Add(TheObject);
  ObjSet.Clear;

  Check(not ObjectDied, 'The object should not have been cleaned up!');
  ObjSet.Add(TheObject);
  ObjSet.OwnsObjects := true;
  Check(ObjSet.OwnsObjects, 'OwnsObjects must be true!');

  ObjSet.Clear;

  Check(ObjectDied, 'The object should have been cleaned up!');
  ObjSet.Free;
end;

initialization
  TestFramework.RegisterTest(TTestHashSet.Suite);

end.
