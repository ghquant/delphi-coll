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

(*
   This sample shows how you can sort a list of custome objects
*)
unit Sort_Person;
interface
uses
  SysUtils,
  DateUtils,
  Generics.Defaults,
  Collections.Base,
  Collections.Dynamic,
  Collections.Lists;

  ///  <summary>Runs the current sample.</summary>
  procedure RunSample();

implementation

type
  { A simple TPerson record that stores some information regarding a person.
    We will create a list of persons and then select only a few fields off each person. }
  TPerson = class
    FFirst, FLast: string;
    FAge: Integer;
    FBirthDate: TDate;
    FBirthLocation: string;

    constructor Create(const AFirst, ALast: string;
      const ABirthDate: TDate; const ABirthLocation: string);
  end;

{ TPerson }

constructor TPerson.Create(const AFirst, ALast: string; const ABirthDate: TDate; const ABirthLocation: string);
begin
  FFirst := AFirst;
  FLast := ALast;
  FBirthDate := ABirthDate;
  FBirthLocation := ABirthLocation;

  { Calculate the age from the birth date }
  FAge := YearsBetween(FBirthDate, Now);
end;


procedure RunSample();
var
  LList: TObjectList<TPerson>;
  LPerson: TPerson;
begin
  WriteLn;
  WriteLn('=============== [Sort_Person] ============ ');
  WriteLn;

  LList := TObjectList<TPerson>.Create;
  try
    LList.OwnsObjects := True;

    { Add a few people }
    LList.Add(TPerson.Create('John', 'McNeill', EncodeDate(1984, 1, 4), 'USA'));
    LList.Add(TPerson.Create('Mary', 'Moskovitz', EncodeDate(1955, 4, 11), 'Ireland'));
    LList.Add(TPerson.Create('Ken', 'Smith', EncodeDate(2001, 8, 23), 'England'));
    LList.Add(TPerson.Create('Lidia', 'Doroftei', EncodeDate(1978, 3, 10), 'Slovakia'));

    { Do a normal sort based on the names }
    LList.Sort(TComparison<TPerson>(
      function(const ALeft, ARight: TPerson): Integer
      begin
        Result := CompareText(ALeft.FLast, ALeft.FLast);
      end));

    for LPerson in LList do
    begin
      WriteLn(LPerson.FFirst + ' ' + LPerson.FLast + ' (' + IntToStr(LPerson.FAge) +  ')');
    end;

    WriteLn;
    WriteLn;
    WriteLn('OrdeBy<Age>:');
    WriteLn;

    { Now try somethign new and order by  }
    for LPerson in LList.Op.OrderBy<Integer>
      (function (Arg1: TPerson): Integer begin Result := Arg1.FAge; end)
    do
    begin
      Writeln(LPerson.FFirst + ' ' + LPerson.FLast + ' (' + IntToStr(LPerson.FAge) +  ')');
    end;

  finally
    LList.Free;
  end;
end;

end.
