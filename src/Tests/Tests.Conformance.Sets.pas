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

unit Tests.Conformance.Sets;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Sets;

type
  TConformance_TAbstractSet<T> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_THashSet<T> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_TObjectHashSet<T: class> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_TLinkedSet<T> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_TObjectLinkedSet<T: class> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_TSortedSet<T> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_TObjectSortedSet<T: class> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_TArraySet<T> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_TObjectArraySet<T: class> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_TBitSet = class(TConformance_ISet<Word>)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Simple.Sets.Integer', [
    TConformance_TAbstractSet<Integer>.Suite,
    TConformance_THashSet<Integer>.Suite,
    TConformance_TLinkedSet<Integer>.Suite,
    TConformance_TSortedSet<Integer>.Suite,
    TConformance_TArraySet<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Sets.String', [
    TConformance_TAbstractSet<String>.Suite,
    TConformance_THashSet<String>.Suite,
    TConformance_TLinkedSet<String>.Suite,
    TConformance_TSortedSet<String>.Suite,
    TConformance_TArraySet<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Sets.Word', [
    TConformance_TBitSet.Suite
  ]);
  RegisterTests('Conformance.Sets.Object', [
    TConformance_TObjectHashSet<TObject>.Suite,
    TConformance_TObjectLinkedSet<TObject>.Suite,
    TConformance_TObjectSortedSet<TObject>.Suite,
    TConformance_TObjectArraySet<TObject>.Suite
  ]);

end.

