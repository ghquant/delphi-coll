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
   This sample shows how the join operations can be used.
*)
unit Joining;
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
  { A simple TPerson record that stores some information regarding a person. }
  TPerson = class
    FFirst, FLast: string;

    constructor Create(const AFirst, ALast: string);
  end;

{ TPerson }

constructor TPerson.Create(const AFirst, ALast: string);
begin
  FFirst := AFirst;
  FLast := ALast;
end;

type
  { A simple TPet record that stores some information regarding a pet. }
  TPet = class
    FName: string;
    FOwner: TPerson;

    constructor Create(const AName: string; const AOwner: TPerson);
  end;

{ TPerson }

constructor TPet.Create(const AName: string; const AOwner: TPerson);
begin
  FName := AName;
  FOwner := AOwner;
end;

type
  { This type is used when selecting the joined results }
  TOwnedPet = record
    FOwnerName: String;
    FPetName: String;
  end;

  { This type is used when selecting the group-joined results }
  TOwnedPets = record
    FOwnerName: String;
    FPetNames: ISequence<String>;
  end;

procedure RunSample();
var
  LOwners: TObjectList<TPerson>;
  LPets: TObjectList<TPet>;
  LJoined: ISequence<TOwnedPet>;
  LOwnedPet: TOwnedPet;
  LGroupJoined: ISequence<TOwnedPets>;
  LOwnedPets: TOwnedPets;
  LName: String;
begin
  WriteLn;
  WriteLn('=============== [Joining] ============ ');
  WriteLn;

  LOwners := TObjectList<TPerson>.Create;
  LOwners.OwnsObjects := True;

  LOwners.Add(TPerson.Create('John', 'McNeill'));
  LOwners.Add(TPerson.Create('Mary', 'Moskovitz'));
  LOwners.Add(TPerson.Create('Ken', 'Smith'));
  LOwners.Add(TPerson.Create('Lidia', 'Doroftei'));
  LOwners.Add(TPerson.Create('Michael', 'Dooley'));
  LOwners.Add(TPerson.Create('Andrea', 'Lonus'));

  LPets := TObjectList<TPet>.Create;
  LPets.OwnsObjects := True;

  LPets.Add(TPet.Create('Sparky', LOwners[0]));
  LPets.Add(TPet.Create('Pookey', LOwners[1]));
  LPets.Add(TPet.Create('Hairy', LOwners[2]));
  LPets.Add(TPet.Create('Skipe', LOwners[3]));
  LPets.Add(TPet.Create('Fluffy', LOwners[2]));
  LPets.Add(TPet.Create('Fatty', LOwners[5]));
  LPets.Add(TPet.Create('Teethy', LOwners[0]));
  LPets.Add(TPet.Create('Cocky', LOwners[0]));
  LPets.Add(TPet.Create('Minty', LOwners[5]));
  LPets.Add(TPet.Create('Abandony', nil));

  WriteLn('Join():');
  WriteLn;

  { Now do the join. We're using the TPerson as the actual key. }
  LJoined := LOwners.Op.Join<TPet, TPerson, TOwnedPet>(LPets,
    function(Arg1: TPerson): TPerson begin Result := Arg1; end, { The outer key selector }
    function(Arg1: TPet): TPerson begin Result := Arg1.FOwner; end, { The inner key selector }
    function(Arg1: TPerson; Arg2: TPet): TOwnedPet
    begin
      Result.FOwnerName := Format('%s, %s', [Arg1.FLast, Arg1.FFirst]);
      Result.FPetName := Arg2.FName;
    end { The result selector }
  );

  for LOwnedPet in LJoined do
  begin
    WriteLn('Person ', LOwnedPet.FOwnerName, ' owns: ', LOwnedPet.FPetName);
  end;

  WriteLn;
  WriteLn('GroupJoin():');
  WriteLn;

  { Now do the join. We're using the TPerson as the actual key. }
  LGroupJoined := LOwners.Op.GroupJoin<TPet, TPerson, TOwnedPets>(LPets,
    function(Arg1: TPerson): TPerson begin Result := Arg1; end, { The outer key selector }
    function(Arg1: TPet): TPerson begin Result := Arg1.FOwner; end, { The inner key selector }
    function(Arg1: TPerson; Arg2: ISequence<TPet>): TOwnedPets
    begin
      Result.FOwnerName := Format('%s, %s', [Arg1.FLast, Arg1.FFirst]);
      Result.FPetNames := Arg2.Op.Select<String>(
        function(Arg1: TPet): String begin Result := Arg1.FName; end);
    end { The result selector }
  );

  for LOwnedPets in LGroupJoined do
  begin
    WriteLn('Person ', LOwnedPets.FOwnerName, ' owns: ');
    Write('    ');

    for LName in LOwnedPets.FPetNames do
      Write(LName, ', ');

    WriteLn;
  end;

  LOwners.Free;
  LPets.Free;
end;

end.
