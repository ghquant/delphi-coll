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

unit Tests.Conformance.Stacks;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Stacks;

type
  TConformance_TAbstractStack<T> = class(TConformance_IStack<T>)
  published
  end;

  TConformance_TStack<T> = class(TConformance_IStack<T>)
  published
  end;

  TConformance_TObjectStack<T: class> = class(TConformance_IStack<T>)
  published
  end;

  TConformance_TLinkedStack<T> = class(TConformance_IStack<T>)
  published
  end;

  TConformance_TObjectLinkedStack<T: class> = class(TConformance_IStack<T>)
  published
  end;

  TConformance_TLinkedList_AsStack<T> = class(TConformance_IStack<T>)
  published
  end;

  TConformance_TObjectLinkedList_AsStack<T: class> = class(TConformance_IStack<T>)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Simple.Stacks.Integer', [
    TConformance_TAbstractStack<Integer>.Suite,
    TConformance_TStack<Integer>.Suite,
    TConformance_TLinkedStack<Integer>.Suite,
    TConformance_TLinkedList_AsStack<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Stacks.String', [
    TConformance_TAbstractStack<String>.Suite,
    TConformance_TStack<String>.Suite,
    TConformance_TLinkedStack<String>.Suite,
    TConformance_TLinkedList_AsStack<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Stacks.Object', [
    TConformance_TObjectStack<TObject>.Suite,
    TConformance_TObjectLinkedStack<TObject>.Suite,
    TConformance_TObjectLinkedList_AsStack<TObject>.Suite
  ]);

end.

