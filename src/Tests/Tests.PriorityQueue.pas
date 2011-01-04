(*
* Copyright (c) 2009-2011, Ciobanu Alexandru
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

unit Tests.PriorityQueue;
interface
uses SysUtils,
     Tests.Utils,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Lists,
     Collections.Queues;

type
  TTestPriorityQueue = class(TTestCaseEx)
  published
    procedure TestCreationAndDestroy();
    procedure TestEnqueueDequeuePeekClearCount();
    procedure TestCopyTo();
    procedure TestIDynamic();
    procedure TestEnumerator();
    procedure TestExceptions();
    procedure TestBigCounts();
    procedure TestObjectVariant();
  end;

implementation

{ TTesTPriorityQueue }

procedure TTestPriorityQueue.TestBigCounts;
const
  NrItems = 100000;
var
  Queue   : TPriorityQueue<Integer, Integer>;
  I, SumK : Integer;
begin
  Queue := TPriorityQueue<Integer, Integer>.Create();

  SumK := 0;

  for I := 0 to NrItems - 1 do
  begin
    Queue.Enqueue(I);
    SumK := SumK + I;
  end;

  while Queue.Count > 0 do
  begin
    SumK := SumK - Queue.Dequeue;
  end;

  Check(SumK = 0, 'Failed to dequeue all items in the queue!');

  Queue.Free;
end;

procedure TTestPriorityQueue.TestCopyTo;
var
  Queue : TPriorityQueue<Integer, Integer>;
  IL    : array of TPair<Integer, Integer>;
begin
  Queue := TPriorityQueue<Integer, Integer>.Create();

  { Add elements to the list }
  Queue.Enqueue(1, 5);
  Queue.Enqueue(2, 4);
  Queue.Enqueue(3, 3);
  Queue.Enqueue(4, 2);
  Queue.Enqueue(5, 1);

  { Check the copy }
  SetLength(IL, 5);
  Queue.CopyTo(IL);

  Check(IL[0].Value = 1, 'Element 0 in the new array is wrong!');
  Check(IL[1].Value = 2, 'Element 1 in the new array is wrong!');
  Check(IL[2].Value = 3, 'Element 2 in the new array is wrong!');
  Check(IL[3].Value = 4, 'Element 3 in the new array is wrong!');
  Check(IL[4].Value = 5, 'Element 4 in the new array is wrong!');
  Check(IL[0].Key = 5, 'Element 0 in the new array is wrong!');
  Check(IL[1].Key = 4, 'Element 1 in the new array is wrong!');
  Check(IL[2].Key = 3, 'Element 2 in the new array is wrong!');
  Check(IL[3].Key = 2, 'Element 3 in the new array is wrong!');
  Check(IL[4].Key = 1, 'Element 4 in the new array is wrong!');


  { Check the copy with index }
  SetLength(IL, 6);
  Queue.CopyTo(IL, 1);

  Check(IL[1].Value = 1, 'Element 1 in the new array is wrong!');
  Check(IL[2].Value = 2, 'Element 2 in the new array is wrong!');
  Check(IL[3].Value = 3, 'Element 3 in the new array is wrong!');
  Check(IL[4].Value = 4, 'Element 4 in the new array is wrong!');
  Check(IL[5].Value = 5, 'Element 5 in the new array is wrong!');
  Check(IL[1].Key = 5, 'Element 0 in the new array is wrong!');
  Check(IL[2].Key = 4, 'Element 1 in the new array is wrong!');
  Check(IL[3].Key = 3, 'Element 2 in the new array is wrong!');
  Check(IL[4].Key = 2, 'Element 3 in the new array is wrong!');
  Check(IL[5].Key = 1, 'Element 4 in the new array is wrong!');

  { Exception  }
  SetLength(IL, 4);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin Queue.CopyTo(IL); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size).'
  );

  SetLength(IL, 5);

  CheckException(EArgumentOutOfSpaceException,
    procedure() begin Queue.CopyTo(IL, 1); end,
    'EArgumentOutOfSpaceException not thrown in CopyTo (too small size +1).'
  );

  Queue.Free();
end;

procedure TTestPriorityQueue.TestCreationAndDestroy;
var
  Queue : TPriorityQueue<Integer, Integer>;
  List  : TLinkedList<TPair<Integer, Integer>>;
  IL    : array of TPair<Integer, Integer>;
begin
  { With default capacity }
  Queue := TPriorityQueue<Integer, Integer>.Create();

  Queue.Enqueue(10);
  Queue.Enqueue(20);
  Queue.Enqueue(30);
  Queue.Enqueue(40);

  Check(Queue.Count = 4, 'Queue count expected to be 4');

  Queue.Free();

  { With preset capacity }
  Queue := TPriorityQueue<Integer, Integer>.Create(0);

  Queue.Enqueue(10, 10);
  Queue.Enqueue(20);
  Queue.Enqueue(30);
  Queue.Enqueue(40, 1);

  Check(Queue.Count = 4, 'Queue count expected to be 4');

  Queue.Free();

  { With Copy }
  List := TLinkedList<TPair<Integer, Integer>>.Create();
  List.AddLast(TPair<Integer, Integer>.Create(11, 1));
  List.AddLast(TPair<Integer, Integer>.Create(2, 2));
  List.AddLast(TPair<Integer, Integer>.Create(3, 3));
  List.AddLast(TPair<Integer, Integer>.Create(10, 4));

  Queue := TPriorityQueue<Integer, Integer>.Create(List);

  Check(Queue.Count = 4, 'Queue count expected to be 4');
  Check(Queue.Dequeue = 1, 'Queue Dequeue expected to be 1');
  Check(Queue.Dequeue = 4, 'Queue Dequeue expected to be 4');
  Check(Queue.Dequeue = 3, 'Queue Dequeue expected to be 3');
  Check(Queue.Dequeue = 2, 'Queue Dequeue expected to be 2');

  List.Free();
  Queue.Free();

  { Copy from array tests }
  SetLength(IL, 5);

  IL[0] := TPair<Integer, Integer>.Create(8, 1);
  IL[1] := TPair<Integer, Integer>.Create(3, 2);
  IL[2] := TPair<Integer, Integer>.Create(12, 3);
  IL[3] := TPair<Integer, Integer>.Create(4, 4);
  IL[4] := TPair<Integer, Integer>.Create(6, 5);

  Queue := TPriorityQueue<Integer, Integer>.Create(IL);
  Queue.Enqueue(6);

  Check(Queue.Count = 6, 'Queue count expected to be 6');
  Check(Queue.Dequeue = 3, 'Queue Dequeue expected to be 3');
  Check(Queue.Dequeue = 1, 'Queue Dequeue expected to be 1');
  Check(Queue.Dequeue = 5, 'Queue Dequeue expected to be 5');
  Check(Queue.Dequeue = 4, 'Queue Dequeue expected to be 4');
  Check(Queue.Dequeue = 2, 'Queue Dequeue expected to be 2');
  Check(Queue.Dequeue = 6, 'Queue Dequeue expected to be 6');

  Queue.Free;

  Queue := TPriorityQueue<Integer, Integer>.Create(IL, false);

  Queue.Enqueue(1, 1);
  Queue.Enqueue(2, 2);
  Queue.Enqueue(3, 3);

  Check(Queue.Dequeue = 1, 'Expected dequeue to return 1');
  Check(Queue.Dequeue = 2, 'Expected dequeue to return 2');
  Check(Queue.Dequeue = 3, 'Expected dequeue to return 3');

  Queue.Free;
end;

procedure TTestPriorityQueue.TestEnumerator;
var
  Queue : TPriorityQueue<Integer, Integer>;
  X  : Integer;
  I: TPair<Integer, Integer>;
begin
  Queue := TPriorityQueue<Integer, Integer>.Create();

  Queue.Enqueue(10, 3);
  Queue.Enqueue(20, 1);
  Queue.Enqueue(30, 10);

  X := 0;

  for I in Queue do
  begin
    if X = 0 then
       Check(I.Value = 30, 'Enumerator failed at 0!')
    else if X = 1 then
       Check(I.Value = 20, 'Enumerator failed at 1!')
    else if X = 2 then
       Check(I.Value = 10, 'Enumerator failed at 2!')
    else
       Fail('Enumerator failed!');

    Inc(X);
  end;

  { Test exceptions }


  CheckException(ECollectionChangedException,
    procedure()
    var
      I: TPair<Integer, Integer>;
    begin
      for I in Queue do
      begin
        Queue.Contains(I.Value);
        Queue.Dequeue();
      end;
    end,
    'ECollectionChangedException not thrown in Enumerator!'
  );

  Check(Queue.Count = 2, 'Enumerator failed too late');

  Queue.Free();
end;

procedure TTestPriorityQueue.TestExceptions;
var
  Queue   : TPriorityQueue<Integer, Integer>;
begin
  Queue := TPriorityQueue<Integer, Integer>.Create();
  Queue.Enqueue(1);
  Queue.Dequeue();

  CheckException(ECollectionEmptyException,
    procedure() begin Queue.Dequeue(); end,
    'ECollectionEmptyException not thrown in Dequeue.'
  );

  CheckException(ECollectionEmptyException,
    procedure() begin Queue.Peek(); end,
    'ECollectionEmptyException not thrown in Peek.'
  );

  Queue.Free();
end;

procedure TTestPriorityQueue.TestIDynamic;
const
  NrElem = 1000;

var
  AQueue: TPriorityQueue<Integer, Integer>;
  I: Integer;
begin
  { With intitial capacity }
  AQueue := TPriorityQueue<Integer, Integer>.Create(100);

  AQueue.Shrink();
  Check(AQueue.Capacity = 0, 'Capacity expected to be 0');
  Check(AQueue.GetCapacity() = AQueue.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AQueue.Grow();
  Check(AQueue.Capacity > 0, 'Capacity expected to be > 0');
  Check(AQueue.GetCapacity() = AQueue.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AQueue.Shrink();
  AQueue.Enqueue(10, 1);
  AQueue.Enqueue(20);
  AQueue.Enqueue(30, 6);
  Check(AQueue.Capacity > AQueue.Count, 'Capacity expected to be > Count');
  Check(AQueue.GetCapacity() = AQueue.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AQueue.Shrink();
  Check(AQueue.Capacity = AQueue.Count, 'Capacity expected to be = Count');
  Check(AQueue.GetCapacity() = AQueue.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AQueue.Grow();
  Check(AQueue.Capacity > AQueue.Count, 'Capacity expected to be > Count');
  Check(AQueue.GetCapacity() = AQueue.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AQueue.Clear();
  AQueue.Shrink();
  Check(AQueue.Capacity = 0, 'Capacity expected to be = 0');
  Check(AQueue.GetCapacity() = AQueue.Capacity, 'GetCapacity() expected to be equal to Capacity');

  for I := 0 to NrElem - 1 do
    AQueue.Enqueue(I);

  for I := 0 to NrElem - 1 do
    AQueue.Dequeue();

  Check(AQueue.Capacity > NrElem, 'Capacity expected to be > NrElem');
  Check(AQueue.GetCapacity() = AQueue.Capacity, 'GetCapacity() expected to be equal to Capacity');

  AQueue.Free;
end;

procedure TTestPriorityQueue.TestObjectVariant;
var
  ObjQueue: TObjectPriorityQueue<TTestObject, TTestObject>;
  TheObject, ThePrio: TTestObject;
  ObjectDied, PrioDied: Boolean;
begin
  ObjQueue := TObjectPriorityQueue<TTestObject, TTestObject>.Create();
  Check(not ObjQueue.OwnsPriorities, 'OwnsPriorities must be false!');
  Check(not ObjQueue.OwnsValues, 'OwnsPriorities must be false!');

  TheObject := TTestObject.Create(@ObjectDied);
  ThePrio := TTestObject.Create(@PrioDied);

  ObjQueue.Enqueue(TheObject, ThePrio);
  ObjQueue.Clear;
  Check(not ObjectDied, 'The object should not have been cleaned up!');
  Check(not PrioDied, 'The prio should not have been cleaned up!');

  ObjQueue.Enqueue(TheObject, ThePrio);
  ObjQueue.OwnsValues := true;
  ObjQueue.OwnsPriorities := true;

  Check(ObjQueue.OwnsValues, 'OwnsValues must be true!');
  Check(ObjQueue.OwnsPriorities, 'OwnsPriorities must be true!');

  ObjQueue.Clear;

  Check(ObjectDied, 'The object should have been cleaned up!');
  Check(PrioDied, 'The prio should have been cleaned up!');

  ObjQueue.Free;
end;

procedure TTestPriorityQueue.TestEnqueueDequeuePeekClearCount;
var
  Queue : TPriorityQueue<Integer, Integer>;
  I     : Integer;
begin
  Queue := TPriorityQueue<Integer, Integer>.Create();

  { Check initialization }
  Queue.Enqueue(1, 10);
  Queue.Enqueue(4, 2);

  Check(Queue.Count = 2, 'Queue Count expected to be 2');
  Check(Queue.GetCount() = 2, 'Queue GetCount expected to be 2');
  Check(Queue.Peek() = 1, 'Queue Peek expected to be 1');

  Queue.Enqueue(10, 11);
  Queue.Enqueue(40);

  Check(Queue.Count = 4, 'Queue Count expected to be 4');
  Check(Queue.GetCount() = 4, 'Queue GetCount expected to be 4');
  Check(Queue.Peek() = 10, 'Queue Peek expected to be 10');

  { Check removing }
  Queue.Dequeue();

  Check(Queue.Count = 3, 'Queue Count expected to be 3');
  Check(Queue.GetCount() = 3, 'Queue GetCount expected to be 3');

  Queue.Dequeue();

  Check(Queue.Count = 2, 'Queue Count expected to be 2');
  Check(Queue.GetCount() = 2, 'Queue GetCount expected to be 2');
  Check(Queue.Peek() = 4, 'Queue Peek expected to be 4');

  Queue.Dequeue();
  Queue.Dequeue();

  Check(Queue.Count = 0, 'Queue Count expected to be 0');
  Check(Queue.GetCount() = 0, 'Queue GetCount expected to be 0');

  Queue.Enqueue(1);

  Check(Queue.Count = 1, 'Queue Count expected to be 1');
  Check(Queue.GetCount() = 1, 'Queue GetCount expected to be 1');

  Queue.Clear();

  Check(Queue.Count = 0, 'Queue Count expected to be 0');
  Check(Queue.GetCount() = 0, 'Queue GetCount expected to be 0');

  Queue.Free();

  Queue := TPriorityQueue<Integer, Integer>.Create();

  for I := 0 to 2048 do
      Queue.Enqueue(I, 2048 - I);

  for I := 0 to 2048 do
      Check(Queue.Dequeue() = I, 'Dequeue failed for I=' + IntToStr(I) + '.');

  Queue.Free();
end;

initialization
  TestFramework.RegisterTest(TTestPriorityQueue.Suite);

end.
