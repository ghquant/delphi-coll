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

unit Tests.Conformance.Lists;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Lists;

type
  TConformance_TAbstractList<T> = class(TConformance_IList<T>)
  published
  end;

  TConformance_TList<T> = class(TConformance_IList<T>)
  published
  end;

  TConformance_TObjectList<T: class> = class(TConformance_IList<T>)
  published
  end;

  TConformance_TSortedList<T> = class(TConformance_IList<T>)
  published
  end;

  TConformance_TObjectSortedList<T: class> = class(TConformance_IList<T>)
  published
  end;

  TConformance_TLinkedList<T> = class(TConformance_ILinkedList<T>)
  published
  end;

  TConformance_TObjectLinkedList<T: class> = class(TConformance_ILinkedList<T>)
  published
  end;

  TConformance_TSortedLinkedList<T> = class(TConformance_IList<T>)
  published
  end;

  TConformance_TObjectSortedLinkedList<T: class> = class(TConformance_ILinkedList<T>)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Simple.Lists.Integer', [
    TConformance_TAbstractList<Integer>.Suite,
    TConformance_TList<Integer>.Suite,
    TConformance_TSortedList<Integer>.Suite,
    TConformance_TLinkedList<Integer>.Suite,
    TConformance_TSortedLinkedList<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Lists.String', [
    TConformance_TAbstractList<String>.Suite,
    TConformance_TList<String>.Suite,
    TConformance_TSortedList<String>.Suite,
    TConformance_TLinkedList<String>.Suite,
    TConformance_TSortedLinkedList<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Lists.Object', [
    TConformance_TObjectList<TObject>.Suite,
    TConformance_TObjectSortedList<TObject>.Suite,
    TConformance_TObjectLinkedList<TObject>.Suite,
    TConformance_TObjectSortedLinkedList<TObject>.Suite
  ]);

end.
