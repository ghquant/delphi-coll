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

unit Tests.Conformance.Bags;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Bags;

type
  TConformance_TAbstractBag<T> = class(TConformance_IBag<T>)
  published
  end;

  TConformance_TBag<T> = class(TConformance_IBag<T>)
  published
  end;

  TConformance_TObjectBag<T: class> = class(TConformance_IBag<T>)
  published
  end;

  TConformance_TSortedBag<T> = class(TConformance_IBag<T>)
  published
  end;

  TConformance_TObjectSortedBag<T: class> = class(TConformance_IBag<T>)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Simple.Bags.Integer', [
    TConformance_TAbstractBag<Integer>.Suite,
    TConformance_TBag<Integer>.Suite,
    TConformance_TSortedBag<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Bags.String', [
    TConformance_TAbstractBag<String>.Suite,
    TConformance_TBag<String>.Suite,
    TConformance_TSortedBag<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Bags.Object', [
    TConformance_TObjectBag<TObject>.Suite,
    TConformance_TObjectSortedBag<TObject>.Suite
  ]);

end.

