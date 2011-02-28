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

unit Tests.Conformance.Dictionaries;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Dictionaries;

type
  TConformance_TAbstractDictionary<TKey, TValue> = class(TConformance_IDictionary<TKey, TValue>)
  published
  end;

  TConformance_TDictionary<TKey, TValue> = class(TConformance_IDictionary<TKey, TValue>)
  published
  end;

  TConformance_TObjectDictionary<TKey, TValue> = class(TConformance_IDictionary<TKey, TValue>)
  published
  end;

  TConformance_TLinkedDictionary<TKey, TValue> = class(TConformance_IDictionary<TKey, TValue>)
  published
  end;

  TConformance_TObjectLinkedDictionary<TKey, TValue> = class(TConformance_IDictionary<TKey, TValue>)
  published
  end;

  TConformance_TSortedDictionary<TKey, TValue> = class(TConformance_IDictionary<TKey, TValue>)
  published
  end;

  TConformance_TObjectSortedDictionary<TKey, TValue> = class(TConformance_IDictionary<TKey, TValue>)
  published
  end;

type
  TConformance_TAbstractDictionary_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TAbstractDictionary_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDictionary_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDictionary_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDictionary_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDictionary_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TLinkedDictionary_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TLinkedDictionary_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectLinkedDictionary_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectLinkedDictionary_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedDictionary_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedDictionary_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedDictionary_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedDictionary_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;


implementation

initialization
  RegisterTests('Conformance.Associative.Dictionaries.Integer/String', [
    TConformance_TAbstractDictionary<Integer, String>.Suite,
    TConformance_TDictionary<Integer, String>.Suite,
    TConformance_TLinkedDictionary<Integer, String>.Suite,
    TConformance_TSortedDictionary<Integer, String>.Suite
  ]);
  RegisterTests('Conformance.Associative.Dictionaries.String/Integer', [
    TConformance_TAbstractDictionary<String, Integer>.Suite,
    TConformance_TDictionary<String, Integer>.Suite,
    TConformance_TLinkedDictionary<String, Integer>.Suite,
    TConformance_TSortedDictionary<String, Integer>.Suite
  ]);
  RegisterTests('Conformance.Associative.Dictionaries.Object/String', [
    TConformance_TObjectDictionary<TObject, String>.Suite,
    TConformance_TObjectLinkedDictionary<TObject, String>.Suite,
    TConformance_TObjectSortedDictionary<TObject, String>.Suite
  ]);
  RegisterTests('Conformance.Associative.Dictionaries.String/Object', [
    TConformance_TObjectDictionary<String, TObject>.Suite,
    TConformance_TObjectLinkedDictionary<String, TObject>.Suite,
    TConformance_TObjectSortedDictionary<String, TObject>.Suite
  ]);

  RegisterTests('Conformance.Simple.Selectors.Integer', [
    TConformance_TAbstractDictionary_Keys<Integer>.Suite,
    TConformance_TAbstractDictionary_Values<Integer>.Suite,
    TConformance_TDictionary_Keys<Integer>.Suite,
    TConformance_TDictionary_Values<Integer>.Suite,
    TConformance_TLinkedDictionary_Keys<Integer>.Suite,
    TConformance_TLinkedDictionary_Values<Integer>.Suite,
    TConformance_TSortedDictionary_Keys<Integer>.Suite,
    TConformance_TSortedDictionary_Values<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Selectors.String', [
    TConformance_TAbstractDictionary_Keys<String>.Suite,
    TConformance_TAbstractDictionary_Values<String>.Suite,
    TConformance_TDictionary_Keys<String>.Suite,
    TConformance_TDictionary_Values<String>.Suite,
    TConformance_TLinkedDictionary_Keys<String>.Suite,
    TConformance_TLinkedDictionary_Values<String>.Suite,
    TConformance_TSortedDictionary_Keys<String>.Suite,
    TConformance_TSortedDictionary_Values<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Selectors.Object', [
    TConformance_TObjectDictionary_Keys<TObject>.Suite,
    TConformance_TObjectDictionary_Values<TObject>.Suite,
    TConformance_TObjectLinkedDictionary_Keys<TObject>.Suite,
    TConformance_TObjectLinkedDictionary_Values<TObject>.Suite,
    TConformance_TObjectSortedDictionary_Keys<TObject>.Suite,
    TConformance_TObjectSortedDictionary_Values<TObject>.Suite
  ]);



end.

