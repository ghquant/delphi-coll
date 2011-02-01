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
   This sample shows how you can select only parts of objects or records by the means of a view.
*)
unit Op_Select_View;
interface
uses
  SysUtils,
  DateUtils,
  Collections.Base,
  Collections.Dynamic,
  Collections.Lists;

  ///  <summary>Runs the current sample.</summary>
  procedure RunSample();

implementation

type
  { A simple TPerson record that stores some information regarding a person.
    We will create a list of persons and then select only a few fields off each person. }
  TPerson = record
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
  LPersList: TList<TPerson>;
  LView: TView;
  LOldest: TDate;
begin
  WriteLn;
  WriteLn('=============== [Op_Select_View] ============ ');
  WriteLn;

  { Create a list of persons }
  LPersList := TList<TPerson>.Create();

  { Add a few people }
  LPersList.Add(TPerson.Create('John', 'McNeill', EncodeDate(1984, 1, 4), 'USA'));
  LPersList.Add(TPerson.Create('Mary', 'Moskovitz', EncodeDate(1955, 4, 11), 'Ireland'));
  LPersList.Add(TPerson.Create('Ken', 'Smith', EncodeDate(2001, 8, 23), 'England'));
  LPersList.Add(TPerson.Create('Lidia', 'Doroftei', EncodeDate(1978, 3, 10), 'Slovakia'));

  { OK! Now we want to select people that are over 20 years old. And we don't need the whole structure
    but simply their first and last names. }

  WriteLn('People over 20 years old are: ');
  for LView in LPersList.Where(
    function(P: TPerson): Boolean begin Exit(P.FAge > 20) end).
      Op.Select(['FFirst', 'FLast']) do
  begin
     { LView is of TView type which is a variant type. It allows dynamic property resolution.
       Each field that we have selected in Select pops up as a property in LView. }
     WriteLn('  ', LView.FFirst, ' ', LView.FLast);
  end;

  WriteLn;

  { We can only select just one field. This is a bit more optimized since it does not create a custom variant.
    First approach, select using strong typing. This example will select just the birth dates from all the people and
    will get the biggest one. }
  LOldest := LPersList.Op.Select<TDate>('FBirthDate').Min();
  WriteLn('The oldest person in the group is born on ', DateToStr(LOldest));

  { The second selection approach will not require you to give a type of the field but will instead return
    RTTI.TValues which you can convert to whatever you like. }

  { Kill the collection }
  LPersList.Free;
end;


end.
