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
     Collections.Queues;

type
  TConformance_TAbstractQueue<T> = class(TConformance_IQueue<T>)
  published
  end;

  TConformance_TQueue<T> = class(TConformance_IQueue<T>)
  published
  end;

  TConformance_TObjectQueue<T: class> = class(TConformance_IQueue<T>)
  published
  end;

  TConformance_TLinkedQueue<T> = class(TConformance_IQueue<T>)
  published
  end;

  TConformance_TObjectLinkedQueue<T: class> = class(TConformance_IQueue<T>)
  published
  end;

  TConformance_TLinkedList_AsQueue<T> = class(TConformance_IQueue<T>)
  published
  end;

  TConformance_TObjectLinkedList_AsQueue<T: class> = class(TConformance_IQueue<T>)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Simple.Queues.Integer', [
    TConformance_TAbstractQueue<Integer>.Suite,
    TConformance_TQueue<Integer>.Suite,
    TConformance_TLinkedQueue<Integer>.Suite,
    TConformance_TLinkedList_AsQueue<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Queues.String', [
    TConformance_TAbstractQueue<String>.Suite,
    TConformance_TQueue<String>.Suite,
    TConformance_TLinkedQueue<String>.Suite,
    TConformance_TLinkedList_AsQueue<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Queues.Object', [
    TConformance_TObjectQueue<TObject>.Suite,
    TConformance_TObjectLinkedQueue<TObject>.Suite,
    TConformance_TObjectLinkedList_AsQueue<TObject>.Suite
  ]);

end.

