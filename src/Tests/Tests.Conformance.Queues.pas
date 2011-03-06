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

unit Tests.Conformance.Queues;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Lists,
     Collections.Queues;

type
  TConformance_TQueue = class(TConformance_IQueue)
  protected
    procedure SetUp_IQueue(out AEmpty, AOne, AFull: IQueue<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TLinkedQueue = class(TConformance_IQueue)
  protected
    procedure SetUp_IQueue(out AEmpty, AOne, AFull: IQueue<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TLinkedList_AsQueue = class(TConformance_IQueue)
  protected
    procedure SetUp_IQueue(out AEmpty, AOne, AFull: IQueue<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

implementation

{ TConformance_TQueue }

procedure TConformance_TQueue.SetUp_IQueue(out AEmpty, AOne,
  AFull: IQueue<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TQueue<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();
  AOrdering := oInsert;

  LEmpty := TQueue<NativeInt>.Create(); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TQueue<NativeInt>.Create(); LOne.RemoveNotification := RemoveNotification;
  LOne.Enqueue(AElements[0]);
  LFull := TQueue<NativeInt>.Create(); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Enqueue(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TLinkedQueue }

procedure TConformance_TLinkedQueue.SetUp_IQueue(out AEmpty, AOne,
  AFull: IQueue<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TLinkedQueue<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();
  AOrdering := oInsert;

  LEmpty := TLinkedQueue<NativeInt>.Create(); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TLinkedQueue<NativeInt>.Create(); LOne.RemoveNotification := RemoveNotification;
  LOne.Enqueue(AElements[0]);
  LFull := TLinkedQueue<NativeInt>.Create(); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Enqueue(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TLinkedList_AsQueue }

procedure TConformance_TLinkedList_AsQueue.SetUp_IQueue(out AEmpty, AOne,
  AFull: IQueue<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TLinkedList<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();
  AOrdering := oInsert;

  LEmpty := TLinkedList<NativeInt>.Create(); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TLinkedList<NativeInt>.Create(); LOne.RemoveNotification := RemoveNotification;
  LOne.AddLast(AElements[0]);
  LFull := TLinkedList<NativeInt>.Create(); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.AddLast(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

initialization
  RegisterTests('Conformance.Simple.Queues', [
    TConformance_TQueue.Suite,
    TConformance_TLinkedQueue.Suite,
    TConformance_TLinkedList_AsQueue.Suite
  ]);

end.

