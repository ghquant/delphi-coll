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

unit Tests.BitSet;
interface
uses SysUtils,
     Tests.Utils,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Stacks,
     Collections.Sets;

type
  TTestBitSet = class(TTestCaseEx)
  published
    procedure TestCreationAndDestroy();
    procedure TestCountClearAdd();
    procedure TestContains();
    procedure TestCopyTo();
    procedure TestEnumerator();
    procedure TestHardCore();
    procedure TestCorrectOrdering();
  end;

implementation

{ TTestQueue }

procedure TTestBitSet.TestCountClearAdd;
var
  BitSet: TBitSet;
begin
  BitSet := TBitSet.Create(false);

  BitSet.Add(11);
  BitSet.Add(22);
  BitSet.Add(33);

  Check((BitSet.Count = 3) and (BitSet.Count = BitSet.GetCount()), 'BitSet count expected to be 3');

  { 33 22 11 }
  BitSet.Add(0);

  { 33 22 11 00 }
  BitSet.Add(88);

  { 88 33 22 11 00 }
  BitSet.Add(55);

  { 88 55 33 22 11 00 }
  Check((BitSet.Count = 6) and (BitSet.Count = BitSet.GetCount()), 'BitSet count expected to be 6');

  BitSet.Remove(11);

  { 88 55 33 22 00 }
  Check((BitSet.Count = 5) and (BitSet.Count = BitSet.GetCount()), 'BitSet count expected to be 5');
  BitSet.Remove(55);

  { 88 33 22 00 }
  BitSet.Remove(33);

  { 88 22 00 }
  BitSet.Remove(22);

  { 88 00 }
  BitSet.Remove(88);

  { 00 }
  BitSet.Remove(0);

  { Pula }
  Check((BitSet.Count = 0) and (BitSet.Count = BitSet.GetCount()), 'BitSet count expected to be 0');

  BitSet.Free;
end;

procedure TTestBitSet.TestCopyTo;
var
  BitSet: TBitSet;
  IL: array of Word;
begin
  BitSet := TBitSet.Create();

  { Add elements to the BitSet }
  BitSet.Add(1);
  BitSet.Add(2);
  BitSet.Add(3);
  BitSet.Add(4);
  BitSet.Add(5);

  { Check the copy }
  SetLength(IL, 5);
  BitSet.CopyTo(IL);

  Check(IL[0] = 1, 'Element 0 in the new array is wrong!');
  Check(IL[1] = 2, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 3, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 4, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 5, 'Element 4 in the new array is wrong!');

  { Check the copy with index }
  SetLength(IL, 6);
  BitSet.CopyTo(IL, 1);

  Check(IL[1] = 1, 'Element 1 in the new array is wrong!');
  Check(IL[2] = 2, 'Element 2 in the new array is wrong!');
  Check(IL[3] = 3, 'Element 3 in the new array is wrong!');
  Check(IL[4] = 4, 'Element 4 in the new array is wrong!');
  Check(IL[5] = 5, 'Element 5 in the new array is wrong!');

  { Exception  }
  SetLength(IL, 4);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin BitSet.CopyTo(IL); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size).'
  );

  SetLength(IL, 5);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin BitSet.CopyTo(IL, 1); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size +1).'
  );

  BitSet.Free();
end;

procedure TTestBitSet.TestCorrectOrdering;
const
  MaxNr = 1000;
  MaxRnd = 10000;

var
  AscSet, DescSet : TBitSet;
  I, PI  : Word;
  B: Boolean;
begin
  { One ascending }
  AscSet := TBitSet.Create(true);

  { ... and one not }
  DescSet := TBitSet.Create(false);

  Randomize;

  { Fill sets with filth }
  for I := 0 to MaxNr - 1 do
  begin
    AscSet.Add(Random(MaxRnd));
    DescSet.Add(Random(MaxRnd));
  end;

  { Enumerate the ascending and check that each key is bigger than the prev one }
  B := true;
  for I in AscSet do
  begin
    if not B then
      Check(I > PI, 'Failed enumeration! Expected that -- always: Vi > Vi-1 for ascending sorted set.')
    else
      PI := I;
  end;

  { Enumerate the ascending and check that each key is lower than the prev one }
  PI := MaxRnd;
  for I in DescSet do
  begin
    Check(I < PI, 'Failed enumeration! Expected that -- always: Vi-1 > Vi for descending sorted set. at ' + IntToStr(PI));
    PI := I;
  end;

  AscSet.Free;
  DescSet.Free;
end;

procedure TTestBitSet.TestContains;
var
  BitSet: TBitSet;
begin
  BitSet := TBitSet.Create();

  BitSet.Add(1);
  BitSet.Add(2);
  BitSet.Add(3);
  BitSet.Add(4);   {-}
  BitSet.Add(5);
  BitSet.Add(6);
  BitSet.Add(4);   {-}
  BitSet.Add(7);
  BitSet.Add(8);
  BitSet.Add(9);

  Check(BitSet.Contains(1), 'Set expected to contain 1');
  Check(BitSet.Contains(2), 'Set expected to contain 2');
  Check(BitSet.Contains(3), 'Set expected to contain 3');
  Check(BitSet.Contains(4), 'Set expected to contain 4');
  Check(not BitSet.Contains(10), 'Set not expected to contain 10');

  BitSet.Free();
end;

procedure TTestBitSet.TestCreationAndDestroy;
var
  BitSet: TBitSet;
  Stack: TStack<Word>;
  IL: array of Word;
begin
  { With default capacity }
  BitSet := TBitSet.Create();

  BitSet.Add(10);
  BitSet.Add(20);
  BitSet.Add(30);
  BitSet.Add(40);

  Check(BitSet.Count = 4, 'BitSet count expected to be 4)');

  BitSet.Free();

  { With preset capacity }
  BitSet := TBitSet.Create();

  BitSet.Add(10);
  BitSet.Add(20);
  BitSet.Add(30);
  BitSet.Add(40);

  Check(BitSet.Count = 4, 'BitSet count expected to be 4)');

  BitSet.Free();

  { With Copy }
  Stack := TStack<Word>.Create();
  Stack.Push(1);
  Stack.Push(2);
  Stack.Push(3);
  Stack.Push(4);

  BitSet := TBitSet.Create(Stack);

  Check(BitSet.Count = 4, 'BitSet count expected to be 4)');
  Check(BitSet.Contains(1), 'BitSet[1] expected to exist)');
  Check(BitSet.Contains(2), 'BitSet[2] expected to exist)');
  Check(BitSet.Contains(3), 'BitSet[3] expected to exist)');
  Check(BitSet.Contains(4), 'BitSet[4] expected to exist)');

  BitSet.Free();
  Stack.Free();

  { Copy from array tests }
  SetLength(IL, 6);

  IL[0] := 1;
  IL[1] := 2;
  IL[2] := 3;
  IL[3] := 4;
  IL[4] := 5;
  IL[5] := 5;

  BitSet := TBitSet.Create(IL);

  Check(BitSet.Count = 5, 'BitSet count expected to be 5');

  Check(BitSet.Contains(1), 'BitSet expected to contain 1');
  Check(BitSet.Contains(2), 'BitSet expected to contain 2');
  Check(BitSet.Contains(3), 'BitSet expected to contain 3');
  Check(BitSet.Contains(4), 'BitSet expected to contain 4');
  Check(BitSet.Contains(5), 'BitSet expected to contain 5');

  BitSet.Free;
end;

procedure TTestBitSet.TestEnumerator;
var
  BitSet: TBitSet;
  I, X: Word;
begin
  BitSet := TBitSet.Create();

  BitSet.Add(10);
  BitSet.Add(20);
  BitSet.Add(30);

  X := 0;

  for I in BitSet do
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
      for I in BitSet do
      begin
        BitSet.Remove(I);
      end;
    end,
    'ECollectionChangedException not thrown in Enumerator!'
  );

  Check(BitSet.Count = 2, 'Enumerator failed too late');

  BitSet.Free();
end;

procedure TTestBitSet.TestHardCore;
const
  NrCont = 10000;

var
  ASet: ISet<Word>;
  I: Word;

begin
  ASet := TBitSet.Create();

  for I := 0 to NrCont - 1 do
    ASet.Add(I);

  for I := 0 to NrCont - 1 do
    ASet.Remove(I);

  Check(ASet.Count = 0, 'Expected an empty set!');
end;


initialization
  TestFramework.RegisterTest(TTestBitSet.Suite);

end.
