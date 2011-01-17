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

unit Tests.LinkedSet;
interface
uses SysUtils,
     Tests.Utils,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Stacks,
     Collections.Sets;

type
  TTestLinkedSet = class(TTestCaseEx)
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

procedure TTestLinkedSet.TestCountClearAdd;
var
  LinkedSet  : TLinkedSet<String>;
  Stack : TStack<String>;
begin
  LinkedSet := TLinkedSet<String>.Create(0);
  Stack := TStack<String>.Create();

  Stack.Push('s1');
  Stack.Push('s2');
  Stack.Push('s3');

  LinkedSet.Add('1');
  LinkedSet.Add('2');
  LinkedSet.Add('3');

  Check((LinkedSet.Count = 3) and (LinkedSet.Count = LinkedSet.GetCount()), 'LinkedSet count expected to be 3');

  { 1 2 3 }
  LinkedSet.Add('0');

  { 1 2 3 0 }
  LinkedSet.Add('-1');

  { 1 2 3 0 -1 }
  LinkedSet.Add('5');

  Check((LinkedSet.Count = 6) and (LinkedSet.Count = LinkedSet.GetCount()), 'LinkedSet count expected to be 6');


  LinkedSet.Remove('1');

  Check((LinkedSet.Count = 5) and (LinkedSet.Count = LinkedSet.GetCount()), 'LinkedSet count expected to be 5');

  LinkedSet.Remove('5');
  LinkedSet.Remove('3');
  LinkedSet.Remove('2');
  LinkedSet.Remove('-1');
  LinkedSet.Remove('0');

  Check((LinkedSet.Count = 0) and (LinkedSet.Count = LinkedSet.GetCount()), 'LinkedSet count expected to be 0');

  LinkedSet.Free;
  Stack.Free;

end;

procedure TTestLinkedSet.TestCopyTo;
var
  LinkedSet  : TLinkedSet<Integer>;
  IL    : array of Integer;
begin
  LinkedSet := TLinkedSet<Integer>.Create();

  { Add elements to the LinkedSet }
  LinkedSet.Add(1);
  LinkedSet.Add(2);
  LinkedSet.Add(3);
  LinkedSet.Add(4);
  LinkedSet.Add(5);

  { Check the copy }
  SetLength(IL, 5);
  LinkedSet.CopyTo(IL);

  Check(IL[0] = 1, 'Element 0 in the new array is wrong!');
  Check(IL[1] = 2, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 3, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 4, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 5, 'Element 4 in the new array is wrong!');

  { Check the copy with index }
  SetLength(IL, 6);
  LinkedSet.CopyTo(IL, 1);

  Check(IL[1] = 1, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 2, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 3, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 4, 'Element 4 in the new array is wrong!');
  Check(IL[5] = 5, 'Element 5 in the new array is wrong!');

  { Exception  }
  SetLength(IL, 4);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin LinkedSet.CopyTo(IL); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size).'
  );

  SetLength(IL, 5);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin LinkedSet.CopyTo(IL, 1); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size +1).'
  );

  LinkedSet.Free();
end;

procedure TTestLinkedSet.TestContains;
var
  LinkedSet  : TLinkedSet<Integer>;
begin
  LinkedSet := TLinkedSet<Integer>.Create();

  LinkedSet.Add(1);
  LinkedSet.Add(2);
  LinkedSet.Add(3);
  LinkedSet.Add(4);   {-}
  LinkedSet.Add(5);
  LinkedSet.Add(6);
  LinkedSet.Add(4);   {-}
  LinkedSet.Add(7);
  LinkedSet.Add(8);
  LinkedSet.Add(9);

  Check(LinkedSet.Contains(1), 'Set expected to contain 1');
  Check(LinkedSet.Contains(2), 'Set expected to contain 2');
  Check(LinkedSet.Contains(3), 'Set expected to contain 3');
  Check(LinkedSet.Contains(4), 'Set expected to contain 4');
  Check(not LinkedSet.Contains(10), 'Set not expected to contain 10');

  LinkedSet.Free();
end;

procedure TTestLinkedSet.TestCreationAndDestroy;
var
  LinkedSet : TLinkedSet<Integer>;
  Stack : TStack<Integer>;
  IL    : array of Integer;
begin
  { With default capacity }
  LinkedSet := TLinkedSet<Integer>.Create();

  LinkedSet.Add(10);
  LinkedSet.Add(20);
  LinkedSet.Add(30);
  LinkedSet.Add(40);

  Check(LinkedSet.Count = 4, 'LinkedSet count expected to be 4)');

  LinkedSet.Free();

  { With preset capacity }
  LinkedSet := TLinkedSet<Integer>.Create(0);

  LinkedSet.Add(10);
  LinkedSet.Add(20);
  LinkedSet.Add(30);
  LinkedSet.Add(40);

  Check(LinkedSet.Count = 4, 'LinkedSet count expected to be 4)');

  LinkedSet.Free();

  { With Copy }
  Stack := TStack<Integer>.Create();
  Stack.Push(1);
  Stack.Push(2);
  Stack.Push(3);
  Stack.Push(4);

  LinkedSet := TLinkedSet<Integer>.Create(Stack);

  Check(LinkedSet.Count = 4, 'LinkedSet count expected to be 4)');
  Check(LinkedSet.Contains(1), 'LinkedSet[1] expected to exist)');
  Check(LinkedSet.Contains(2), 'LinkedSet[2] expected to exist)');
  Check(LinkedSet.Contains(3), 'LinkedSet[3] expected to exist)');
  Check(LinkedSet.Contains(4), 'LinkedSet[4] expected to exist)');

  LinkedSet.Free();
  Stack.Free();

  { Copy from array tests }
  SetLength(IL, 6);

  IL[0] := 1;
  IL[1] := 2;
  IL[2] := 3;
  IL[3] := 4;
  IL[4] := 5;
  IL[5] := 5;

  LinkedSet := TLinkedSet<Integer>.Create(IL);

  Check(LinkedSet.Count = 5, 'LinkedSet count expected to be 5');

  Check(LinkedSet.Contains(1), 'LinkedSet expected to contain 1');
  Check(LinkedSet.Contains(2), 'LinkedSet expected to contain 2');
  Check(LinkedSet.Contains(3), 'LinkedSet expected to contain 3');
  Check(LinkedSet.Contains(4), 'LinkedSet expected to contain 4');
  Check(LinkedSet.Contains(5), 'LinkedSet expected to contain 5');

  LinkedSet.Free;
end;

procedure TTestLinkedSet.TestEnumerator;
var
  LinkedSet : TLinkedSet<Integer>;
  I, X  : Integer;
begin
  LinkedSet := TLinkedSet<Integer>.Create();

  LinkedSet.Add(10);
  LinkedSet.Add(20);
  LinkedSet.Add(30);

  X := 0;

  for I in LinkedSet do
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
      for I in LinkedSet do
      begin
        LinkedSet.Remove(I);
      end;
    end,
    'ECollectionChangedException not thrown in Enumerator!'
  );

  Check(LinkedSet.Count = 2, 'Enumerator failed too late');

  LinkedSet.Free();
end;

procedure TTestLinkedSet.TestHardCore;
const
  NrCont = 10000;

var
  ASet: ISet<Integer>;
  I: Integer;

begin
  ASet := TLinkedSet<Integer>.Create();

  for I := 0 to NrCont - 1 do
    ASet.Add(I);

  for I := 0 to NrCont - 1 do
    ASet.Remove(I);

  Check(ASet.Count = 0, 'Expected an empty set!');
end;

procedure TTestLinkedSet.TestObjectVariant;
var
  ObjSet: TObjectLinkedSet<TTestObject>;
  TheObject: TTestObject;
  ObjectDied: Boolean;
begin
  ObjSet := TObjectLinkedSet<TTestObject>.Create();
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
  TestFramework.RegisterTest(TTestLinkedSet.Suite);

end.
