(*
* Copyright (c) 2009-2010, Ciobanu Alexandru
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

{$I Collections.Defines.inc}
unit Collections.MultiMaps;
interface
uses SysUtils,
     DeHL.Base,
     DeHL.Types,
     DeHL.Exceptions,
     DeHL.Arrays,
     DeHL.Collections.Base,
     DeHL.Collections.Abstract,
     DeHL.Collections.List,
     DeHL.Collections.Dictionary;

type
type
  ///  <summary>The base abstract class for all <c>multi-maps</c> in DeHL.</summary>
  TAbstractMultiMap<TKey, TValue> = class abstract(TEnexAssociativeCollection<TKey, TValue>, IMultiMap<TKey, TValue>)
  private type
    {$REGION 'Internal Types'}
    { Generic MultiMap Pairs Enumerator }
    TPairEnumerator = class(TEnumerator<KVPair<TKey,TValue>>)
    private
      FVer: NativeUInt;
      FDict: TAbstractMultiMap<TKey, TValue>;
      FValue: KVPair<TKey, TValue>;

      FListIndex: NativeUInt;
      FDictEnum: IEnumerator<KVPair<TKey, IList<TValue>>>;
      FList: IList<TValue>;

    public
      { Constructor }
      constructor Create(const ADict: TAbstractMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): KVPair<TKey,TValue>; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic MultiMap Keys Enumerator }
    TKeyEnumerator = class(TEnumerator<TKey>)
    private
      FVer: NativeUInt;
      FDict: TAbstractMultiMap<TKey, TValue>;
      FValue: TKey;
      FDictEnum: IEnumerator<TKey>;

    public
      { Constructor }
      constructor Create(const ADict: TAbstractMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TKey; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic MultiMap Values Enumerator }
    TValueEnumerator = class(TEnumerator<TValue>)
    private
      FVer: NativeUInt;
      FDict: TAbstractMultiMap<TKey, TValue>;
      FValue: TValue;

      FListIndex: NativeUInt;
      FDictEnum: IEnumerator<IList<TValue>>;
      FList: IList<TValue>;

    public
      { Constructor }
      constructor Create(const ADict: TAbstractMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TValue; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic MultiMap Keys Collection }
    TKeyCollection = class(TEnexCollection<TKey>)
    private
      FDict: TAbstractMultiMap<TKey, TValue>;

    protected
      { Hidden }
      function GetCount(): NativeUInt; override;
    public
      { Constructor }
      constructor Create(const ADict: TAbstractMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      { Property }
      property Count: NativeUInt read GetCount;

      { IEnumerable/ ICollection support }
      function GetEnumerator(): IEnumerator<TKey>; override;

      { Copy-To }
      procedure CopyTo(var AArray: array of TKey; const StartIndex: NativeUInt); overload; override;

      { Enex Overrides }
      function Empty(): Boolean; override;
    end;

    { Generic MultiMap Values Collection }
    TValueCollection = class(TEnexCollection<TValue>)
    private
      FDict: TAbstractMultiMap<TKey, TValue>;

    protected

      { Hidden }
      function GetCount: NativeUInt; override;
    public
      { Constructor }
      constructor Create(const ADict: TAbstractMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      { Property }
      property Count: NativeUInt read GetCount;

      { IEnumerable/ ICollection support }
      function GetEnumerator(): IEnumerator<TValue>; override;

      { Copy-To }
      procedure CopyTo(var AArray: array of TValue; const StartIndex: NativeUInt); overload; override;

      { Enex Overrides }
      function Empty(): Boolean; override;
    end;
    {$ENDREGION}

  private
    FVer: NativeUInt;
    FKnownCount: NativeUInt;
    FEmptyList: IEnexIndexedCollection<TValue>;
    FKeyCollection: IEnexCollection<TKey>;
    FValueCollection: IEnexCollection<TValue>;
    FDictionary: IDictionary<TKey, IList<TValue>>;

  protected
    ///  <summary>Specifies the internal dictionary used as back-end.</summary>
    ///  <returns>A dictionary of lists used as back-end.</summary>
    property Dictionary: IDictionary<TKey, IList<TValue>> read FDictionary;

    ///  <summary>Returns the number of pairs in the multi-map.</summary>
    ///  <returns>A positive value specifying the total number of pairs in the multi-map.</returns>
    ///  <remarks>The value returned by this method represents the total number of key-value pairs
    ///  stored in the dictionary. In a multi-map this means that each value associated with a key
    ///  is calculated as a pair. If a key has multiple values associated with it, each key-value
    ///  combination is calculated as one.</remarks>
    function GetCount(): NativeUInt; override;

    ///  <summary>Returns the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <returns>An Enex collection that contains the values associated with this key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">The key is not found in the collection.</exception>
    function GetItemList(const AKey: TKey): IEnexIndexedCollection<TValue>;

    ///  <summary>Called when the map needs to initialize its internal dictionary.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    function CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, IList<TValue>>; virtual; abstract;

    ///  <summary>Called when the map needs to initialize a list assoiated with a key.</summary>
    ///  <param name="AValueType">The type object describing the values.</param>
    function CreateList(const AValueType: IType<TValue>): IList<TValue>; virtual; abstract;

  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const ACollection: IEnumerable<KVPair<TKey,TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of KVPair<TKey,TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TFixedArray<KVPair<TKey, TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <param name="ACollection">A collection to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const ACollection: IEnumerable<KVPair<TKey,TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: array of KVPair<TKey,TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: TDynamicArray<KVPair<TKey,TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: TFixedArray<KVPair<TKey,TValue>>); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead.</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the multi-map.</summary>
    ///  <remarks>This method clears the multi-map and invokes type object's cleaning routines for key and value.</remarks>
    procedure Clear();

    ///  <summary>Adds a key-value pair to the multi-map.</summary>
    ///  <param name="APair">The key-value pair to add.</param>
    ///  <exception cref="DeHL.Exceptions|EDuplicateKeyException">The multi-map already contains a pair with the given key.</exception>
    procedure Add(const APair: KVPair<TKey, TValue>); overload;

    ///  <summary>Adds a key-value pair to the multi-map.</summary>
    ///  <param name="AKey">The key of pair.</param>
    ///  <param name="AValue">The value associated with the key.</param>
    ///  <exception cref="DeHL.Exceptions|EDuplicateKeyException">The multi-map already contains a pair with the given key.</exception>
    procedure Add(const AKey: TKey; const AValue: TValue); overload;

    ///  <summary>Removes a key-value pair using a given key.</summary>
    ///  <param name="AKey">The key of pair.</param>
    ///  <remarks>This invokes type object's cleaning routines for value
    ///  associated with the key. If the specified key was not found in the multi-map, nothing happens.</remarks>
    procedure Remove(const AKey: TKey); overload;

    ///  <summary>Removes a key-value pair using a given key and value.</summary>
    ///  <param name="AKey">The key associated with the value.</param>
    ///  <param name="AValue">The value to remove.</param>
    ///  <remarks>A multi-map allows storing multiple values for a given key. This method allows removing only the
    ///  specified value from the collection of values associated with the given key.</remarks>
    procedure Remove(const AKey: TKey; const AValue: TValue); overload;

    ///  <summary>Removes a key-value pair using a given key and value.</summary>
    ///  <param name="APair">The key and its associated value to remove.</param>
    ///  <remarks>A multi-map allows storing multiple values for a given key. This method allows removing only the
    ///  specified value from the collection of values associated with the given key.</remarks>
    procedure Remove(const APair: KVPair<TKey, TValue>); overload;

    ///  <summary>Checks whether the multi-map contains a key-value pair identified by the given key.</summary>
    ///  <param name="AKey">The key to check for.</param>
    ///  <returns><c>True</c> if the map contains a pair identified by the given key; <c>False</c> otherwise.</returns>
    function ContainsKey(const AKey: TKey): Boolean;

    ///  <summary>Checks whether the multi-map contains a key-value pair that contains a given value.</summary>
    ///  <param name="AValue">The value to check for.</param>
    ///  <returns><c>True</c> if the multi-map contains a pair containing the given value; <c>False</c> otherwise.</returns>
    function ContainsValue(const AValue: TValue): Boolean; overload;

    ///  <summary>Checks whether the multi-map contains a given key-value combination.</summary>
    ///  <param name="AKey">The key associated with the value.</param>
    ///  <param name="AValue">The value associated with the key.</param>
    ///  <returns><c>True</c> if the map contains the given association; <c>False</c> otherwise.</returns>
    function ContainsValue(const AKey: TKey; const AValue: TValue): Boolean; overload;

    ///  <summary>Checks whether the multi-map contains a given key-value combination.</summary>
    ///  <param name="APair">The key-value pair to check for.</param>
    ///  <returns><c>True</c> if the map contains the given association; <c>False</c> otherwise.</returns>
    function ContainsValue(const APair: KVPair<TKey, TValue>): Boolean; overload;

    ///  <summary>Tries to extract the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <param name="AValues">The Enex collection that stores the associated values.</param>
    ///  <returns><c>True</c> if the key exists in the collection; <c>False</c> otherwise;</returns>
    function TryGetValues(const AKey: TKey; out AValues: IEnexIndexedCollection<TValue>): Boolean; overload;

    ///  <summary>Tries to extract the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <returns>The associated collection if the key if valid; an empty collection otherwise.</returns>
    function TryGetValues(const AKey: TKey): IEnexIndexedCollection<TValue>; overload;

    ///  <summary>Returns the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <returns>An Enex collection that contains the values associated with this key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">The key is not found in the multi-map.</exception>
    property Items[const AKey: TKey]: IEnexIndexedCollection<TValue> read GetItemList; default;

    ///  <summary>Returns the number of pairs in the multi-map.</summary>
    ///  <returns>A positive value specifying the total number of pairs in the multi-map.</returns>
    ///  <remarks>The value returned by this method represents the total number of key-value pairs
    ///  stored in the dictionary. In a multi-map this means that each value associated with a key
    ///  is calculated as a pair. If a key has multiple values associated with it, each key-value
    ///  combination is calculated as one.</remarks>
    property Count: NativeUInt read FKnownCount;

    ///  <summary>Specifies the collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the multi-map.</returns>
    property Keys: IEnexCollection<TKey> read FKeyCollection;

    ///  <summary>Specifies the collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the multi-map.</returns>
    property Values: IEnexCollection<TValue> read FValueCollection;

    ///  <summary>Returns a new enumerator object used to enumerate this multi-map.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the multi-map.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<KVPair<TKey,TValue>>; override;

    ///  <summary>Copies the values stored in the multi-map to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the multi-map.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the multi-map.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of KVPair<TKey,TValue>; const AStartIndex: NativeUInt); overload; override;

    ///  <summary>Returns the value associated with the given key.</summary>
    ///  <param name="AKey">The key for which to return the associated value.</param>
    ///  <returns>The value associated with the given key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">No such key in the multi-map.</exception>
    function ValueForKey(const AKey: TKey): TValue; override;

    ///  <summary>Checks whether the multi-map contains a given key-value pair.</summary>
    ///  <param name="AKey">The key part of the pair.</param>
    ///  <param name="AValue">The value part of the pair.</param>
    ///  <returns><c>True</c> if the given key-value pair exists; <c>False</c> otherwise.</returns>
    function KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean; override;

    ///  <summary>Returns an Enex collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the multi-map.</returns>
    function SelectKeys(): IEnexCollection<TKey>; override;

    ///  <summary>Returns a Enex collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the multi-map.</returns>
    function SelectValues(): IEnexCollection<TValue>; override;
  end;

type
  ///  <summary>The base abstract class for all <c>distinct multi-maps</c> in DeHL.</summary>
  TAbstractDistinctMultiMap<TKey, TValue> = class abstract(TEnexAssociativeCollection<TKey, TValue>, IDistinctMultiMap<TKey, TValue>)
  private type
    {$REGION 'Internal Types'}
    { Generic MultiMap Pairs Enumerator }
    TPairEnumerator = class(TEnumerator<KVPair<TKey,TValue>>)
    private
      FVer: NativeUInt;
      FDict: TAbstractDistinctMultiMap<TKey, TValue>;
      FValue: KVPair<TKey, TValue>;

      FSetEnum: IEnumerator<TValue>;
      FDictEnum: IEnumerator<KVPair<TKey, ISet<TValue>>>;
      FSet: ISet<TValue>;

    public
      { Constructor }
      constructor Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): KVPair<TKey,TValue>; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic MultiMap Keys Enumerator }
    TKeyEnumerator = class(TEnumerator<TKey>)
    private
      FVer: NativeUInt;
      FDict: TAbstractDistinctMultiMap<TKey, TValue>;
      FValue: TKey;
      FDictEnum: IEnumerator<TKey>;

    public
      { Constructor }
      constructor Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TKey; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic MultiMap Values Enumerator }
    TValueEnumerator = class(TEnumerator<TValue>)
    private
      FVer: NativeUInt;
      FDict: TAbstractDistinctMultiMap<TKey, TValue>;
      FValue: TValue;

      FDictEnum: IEnumerator<ISet<TValue>>;
      FSetEnum: IEnumerator<TValue>;
      FSet: ISet<TValue>;

    public
      { Constructor }
      constructor Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TValue; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic MultiMap Keys Collection }
    TKeyCollection = class(TEnexCollection<TKey>)
    private
      FDict: TAbstractDistinctMultiMap<TKey, TValue>;

    protected
      { Hidden }
      function GetCount(): NativeUInt; override;
    public
      { Constructor }
      constructor Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      { Property }
      property Count: NativeUInt read GetCount;

      { IEnumerable/ ICollection support }
      function GetEnumerator(): IEnumerator<TKey>; override;

      { Copy-To }
      procedure CopyTo(var AArray: array of TKey; const StartIndex: NativeUInt); overload; override;

      { Enex Overrides }
      function Empty(): Boolean; override;
    end;

    { Generic MultiMap Values Collection }
    TValueCollection = class(TEnexCollection<TValue>)
    private
      FDict: TAbstractDistinctMultiMap<TKey, TValue>;

    protected
      { Hidden }
      function GetCount: NativeUInt; override;

    public
      { Constructor }
      constructor Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      { Property }
      property Count: NativeUInt read GetCount;

      { IEnumerable/ ICollection support }
      function GetEnumerator(): IEnumerator<TValue>; override;

      { Copy-To }
      procedure CopyTo(var AArray: array of TValue; const StartIndex: NativeUInt); overload; override;

      { Enex Overrides }
      function Empty(): Boolean; override;
    end;
    {$ENDREGION}

  private var
    FVer: NativeUInt;
    FKnownCount: NativeUInt;
    FEmptySet: IEnexCollection<TValue>;
    FKeyCollection: IEnexCollection<TKey>;
    FValueCollection: IEnexCollection<TValue>;
    FDictionary: IDictionary<TKey, ISet<TValue>>;

  protected
    ///  <summary>Specifies the internal dictionary used as back-end.</summary>
    ///  <returns>A dictionary of lists used as back-end.</summary>
    property Dictionary: IDictionary<TKey, ISet<TValue>> read FDictionary;

    ///  <summary>Returns the number of pairs in the multi-map.</summary>
    ///  <returns>A positive value specifying the total number of pairs in the multi-map.</returns>
    ///  <remarks>The value returned by this method represents the total number of key-value pairs
    ///  stored in the dictionary. In a multi-map this means that each value associated with a key
    ///  is calculated as a pair. If a key has multiple values associated with it, each key-value
    ///  combination is calculated as one.</remarks>
    function GetCount(): NativeUInt; override;

    ///  <summary>Returns the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <returns>An Enex collection that contains the values associated with this key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">The key is not found in the collection.</exception>
    function GetItemList(const AKey: TKey): IEnexCollection<TValue>;

    ///  <summary>Called when the map needs to initialize its internal dictionary.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    function CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, ISet<TValue>>; virtual; abstract;

    ///  <summary>Called when the map needs to initialize a set assoiated with a key.</summary>
    ///  <param name="AValueType">The type object describing the values.</param>
    function CreateSet(const AValueType: IType<TValue>): ISet<TValue>; virtual; abstract;

  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const ACollection: IEnumerable<KVPair<TKey,TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of KVPair<TKey,TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TFixedArray<KVPair<TKey, TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <param name="ACollection">A collection to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const ACollection: IEnumerable<KVPair<TKey,TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: array of KVPair<TKey,TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: TDynamicArray<KVPair<TKey,TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the multi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the multi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: TFixedArray<KVPair<TKey,TValue>>); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead.</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the multi-map.</summary>
    ///  <remarks>This method clears the multi-map and invokes type object's cleaning routines for key and value.</remarks>
    procedure Clear();

    ///  <summary>Adds a key-value pair to the multi-map.</summary>
    ///  <param name="APair">The key-value pair to add.</param>
    ///  <exception cref="DeHL.Exceptions|EDuplicateKeyException">The multi-map already contains a pair with the given key.</exception>
    procedure Add(const APair: KVPair<TKey, TValue>); overload;

    ///  <summary>Adds a key-value pair to the multi-map.</summary>
    ///  <param name="AKey">The key of pair.</param>
    ///  <param name="AValue">The value associated with the key.</param>
    ///  <exception cref="DeHL.Exceptions|EDuplicateKeyException">The multi-map already contains a pair with the given key.</exception>
    procedure Add(const AKey: TKey; const AValue: TValue); overload;

    ///  <summary>Removes a key-value pair using a given key.</summary>
    ///  <param name="AKey">The key of pair.</param>
    ///  <remarks>This invokes type object's cleaning routines for value
    ///  associated with the key. If the specified key was not found in the multi-map, nothing happens.</remarks>
    procedure Remove(const AKey: TKey); overload;

    ///  <summary>Removes a key-value pair using a given key and value.</summary>
    ///  <param name="AKey">The key associated with the value.</param>
    ///  <param name="AValue">The value to remove.</param>
    ///  <remarks>A multi-map allows storing multiple values for a given key. This method allows removing only the
    ///  specified value from the collection of values associated with the given key.</remarks>
    procedure Remove(const AKey: TKey; const AValue: TValue); overload;

    ///  <summary>Removes a key-value pair using a given key and value.</summary>
    ///  <param name="APair">The key and its associated value to remove.</param>
    ///  <remarks>A multi-map allows storing multiple values for a given key. This method allows removing only the
    ///  specified value from the collection of values associated with the given key.</remarks>
    procedure Remove(const APair: KVPair<TKey, TValue>); overload;

    ///  <summary>Checks whether the multi-map contains a key-value pair identified by the given key.</summary>
    ///  <param name="AKey">The key to check for.</param>
    ///  <returns><c>True</c> if the map contains a pair identified by the given key; <c>False</c> otherwise.</returns>
    function ContainsKey(const AKey: TKey): Boolean;

    ///  <summary>Checks whether the multi-map contains a key-value pair that contains a given value.</summary>
    ///  <param name="AValue">The value to check for.</param>
    ///  <returns><c>True</c> if the multi-map contains a pair containing the given value; <c>False</c> otherwise.</returns>
    function ContainsValue(const AValue: TValue): Boolean; overload;

    ///  <summary>Checks whether the multi-map contains a given key-value combination.</summary>
    ///  <param name="AKey">The key associated with the value.</param>
    ///  <param name="AValue">The value associated with the key.</param>
    ///  <returns><c>True</c> if the map contains the given association; <c>False</c> otherwise.</returns>
    function ContainsValue(const AKey: TKey; const AValue: TValue): Boolean; overload;

    ///  <summary>Checks whether the multi-map contains a given key-value combination.</summary>
    ///  <param name="APair">The key-value pair to check for.</param>
    ///  <returns><c>True</c> if the map contains the given association; <c>False</c> otherwise.</returns>
    function ContainsValue(const APair: KVPair<TKey, TValue>): Boolean; overload;

    ///  <summary>Tries to extract the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <param name="AValues">The Enex collection that stores the associated values.</param>
    ///  <returns><c>True</c> if the key exists in the collection; <c>False</c> otherwise;</returns>
    function TryGetValues(const AKey: TKey; out AValues: IEnexCollection<TValue>): Boolean; overload;

    ///  <summary>Tries to extract the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <returns>The associated collection if the key if valid; an empty collection otherwise.</returns>
    function TryGetValues(const AKey: TKey): IEnexCollection<TValue>; overload;

    ///  <summary>Returns the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <returns>An Enex collection that contains the values associated with this key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">The key is not found in the multi-map.</exception>
    property Items[const AKey: TKey]: IEnexCollection<TValue> read GetItemList; default;

    ///  <summary>Returns the number of pairs in the multi-map.</summary>
    ///  <returns>A positive value specifying the total number of pairs in the multi-map.</returns>
    ///  <remarks>The value returned by this method represents the total number of key-value pairs
    ///  stored in the dictionary. In a multi-map this means that each value associated with a key
    ///  is calculated as a pair. If a key has multiple values associated with it, each key-value
    ///  combination is calculated as one.</remarks>
    property Count: NativeUInt read FKnownCount;

    ///  <summary>Specifies the collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the multi-map.</returns>
    property Keys: IEnexCollection<TKey> read FKeyCollection;

    ///  <summary>Specifies the collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the multi-map.</returns>
    property Values: IEnexCollection<TValue> read FValueCollection;

    ///  <summary>Returns a new enumerator object used to enumerate this multi-map.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the multi-map.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<KVPair<TKey,TValue>>; override;

    ///  <summary>Copies the values stored in the multi-map to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the multi-map.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the multi-map.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of KVPair<TKey,TValue>; const AStartIndex: NativeUInt); overload; override;

    ///  <summary>Returns the value associated with the given key.</summary>
    ///  <param name="AKey">The key for which to return the associated value.</param>
    ///  <returns>The value associated with the given key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">No such key in the multi-map.</exception>
    function ValueForKey(const AKey: TKey): TValue; override;

    ///  <summary>Checks whether the multi-map contains a given key-value pair.</summary>
    ///  <param name="AKey">The key part of the pair.</param>
    ///  <param name="AValue">The value part of the pair.</param>
    ///  <returns><c>True</c> if the given key-value pair exists; <c>False</c> otherwise.</returns>
    function KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean; override;

    ///  <summary>Returns an Enex collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the multi-map.</returns>
    function SelectKeys(): IEnexCollection<TKey>; override;

    ///  <summary>Returns a Enex collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the multi-map.</returns>
    function SelectValues(): IEnexCollection<TValue>; override;
  end;

type
  ///  <summary>The generic <c>multi map</c> collection.</summary>
  ///  <remarks>This type uses a <c>dictionary</c> and a number of <c>lists</c> to store its
  ///  keys and values.</remarks>
  TMultiMap<TKey, TValue> = class(TAbstractMultiMap<TKey, TValue>)
  private
    FInitialCapacity: NativeUInt;

  protected
    ///  <summary>Called when the map needs to initialize its internal dictionary.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <remarks>This method creates a hash-based dictionary used as the underlying back-end for the map.</remarks>
    function CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, IList<TValue>>; override;

    ///  <summary>Called when the map needs to initialize a list assoiated with a key.</summary>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a simple array-based list. This list is associated with a key and store the map's
    ///  values for that key.</remarks>
    function CreateList(const AValueType: IType<TValue>): IList<TValue>; override;

  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The map's initial capacity.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AInitialCapacity: NativeUInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AInitialCapacity">The map's initial capacity.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>; const AInitialCapacity: NativeUInt); overload;
  end;

  ///  <summary>The generic <c>multi map</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses a <c>dictionary</c> and a number of <c>lists</c> to store its
  ///  keys and values.</remarks>
  TObjectMultiMap<TKey, TValue: class> = class(TMultiMap<TKey, TValue>)
  private
    FKeyWrapperType: TObjectWrapperType<TKey>;
    FValueWrapperType: TObjectWrapperType<TValue>;

    { Getters/Setters for OwnsKeys }
    function GetOwnsKeys: Boolean;
    procedure SetOwnsKeys(const Value: Boolean);

    { Getters/Setters for OwnsValues }
    function GetOwnsValues: Boolean;
    procedure SetOwnsValues(const Value: Boolean);

  protected
    ///  <summary>Installs the type objects describing the key and the value or the stored pairs.</summary>
    ///  <param name="AKeyType">The key's type object to install.</param>
    ///  <param name="AValueType">The value's type object to install.</param>
    ///  <remarks>This method installs a custom wrapper designed to suppress the cleanup of objects on request.
    ///  Make sure to call this method in descendant classes.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    procedure InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); override;

  public
    ///  <summary>Specifies whether this map owns the keys.</summary>
    ///  <returns><c>True</c> if the map owns the keys; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored keys. The value of this property has effect only
    ///  if the keys are objects, otherwise it is ignored.</remarks>
    property OwnsKeys: Boolean read GetOwnsKeys write SetOwnsKeys;

    ///  <summary>Specifies whether this map owns the values.</summary>
    ///  <returns><c>True</c> if the map owns the values; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored values. The value of this property has effect only
    ///  if the values are objects, otherwise it is ignored.</remarks>
    property OwnsValues: Boolean read GetOwnsValues write SetOwnsValues;
  end;

type
  ///  <summary>The generic <c>multi map</c> collection.</summary>
  ///  <remarks>This type uses a <c>sorted dictionary</c> and a number of <c>lists</c> to store its
  ///  keys and values.</remarks>
  TSortedMultiMap<TKey, TValue> = class(TAbstractMultiMap<TKey, TValue>)
  private
    FAscSort: Boolean;

  protected
    ///  <summary>Called when the map needs to initialize its internal dictionary.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <remarks>This method creates an AVL-dictionary used as the underlying back-end for the map.</remarks>
    function CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, IList<TValue>>; override;

    ///  <summary>Called when the map needs to initialize a list assoiated with a key.</summary>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a simple array-based list. This list is associated with a key and store the map's
    ///  values for that key.</remarks>
    function CreateList(const AValueType: IType<TValue>): IList<TValue>; override;

    ///  <summary>Called when the serialization process is about to begin.</summary>
    ///  <param name="AData">The serialization data exposing the context and other serialization options.</param>
    procedure StartSerializing(const AData: TSerializationData); override;

    ///  <summary>Called when the deserialization process is about to begin.</summary>
    ///  <param name="AData">The deserialization data exposing the context and other deserialization options.</param>
    ///  <exception cref="DeHL.Exceptions|ESerializationException">Default implementation.</exception>
    procedure StartDeserializing(const AData: TDeserializationData); override;

    ///  <summary>Called when the an pair has been deserialized and needs to be inserted into the map.</summary>
    ///  <param name="AKey">The key that was deserialized.</param>
    ///  <param name="AValue">The value that was deserialized.</param>
    ///  <remarks>This method simply adds the element to the map.</remarks>
    procedure DeserializePair(const AKey: TKey; const AValue: TValue); override;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    constructor Create(const ACollection: IEnumerable<KVPair<TKey,TValue>>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of KVPair<TKey,TValue>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TFixedArray<KVPair<TKey, TValue>>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="ACollection">A collection to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const ACollection: IEnumerable<KVPair<TKey,TValue>>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: array of KVPair<TKey,TValue>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: TDynamicArray<KVPair<TKey,TValue>>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: TFixedArray<KVPair<TKey,TValue>>; const AAscending: Boolean = true); overload;

    ///  <summary>Returns the biggest key.</summary>
    ///  <returns>The biggest key stored in the map.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The map is empty.</exception>
    function MaxKey(): TKey; override;

    ///  <summary>Returns the smallest key.</summary>
    ///  <returns>The smallest key stored in the map.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The map is empty.</exception>
    function MinKey(): TKey; override;
  end;

  ///  <summary>The generic <c>multi map</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses a <c>sorted dictionary</c> and a number of <c>lists</c> to store its
  ///  keys and values.</remarks>
  TObjectSortedMultiMap<TKey, TValue> = class(TSortedMultiMap<TKey, TValue>)
  private
    FKeyWrapperType: TMaybeObjectWrapperType<TKey>;
    FValueWrapperType: TMaybeObjectWrapperType<TValue>;

    { Getters/Setters for OwnsKeys }
    function GetOwnsKeys: Boolean;
    procedure SetOwnsKeys(const Value: Boolean);

    { Getters/Setters for OwnsValues }
    function GetOwnsValues: Boolean;
    procedure SetOwnsValues(const Value: Boolean);

  protected
    ///  <summary>Installs the type objects describing the key and the value or the stored pairs.</summary>
    ///  <param name="AKeyType">The key's type object to install.</param>
    ///  <param name="AValueType">The value's type object to install.</param>
    ///  <remarks>This method installs a custom wrapper designed to suppress the cleanup of objects on request.
    ///  Make sure to call this method in descendant classes.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    procedure InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); override;

  public
    ///  <summary>Specifies whether this map owns the keys.</summary>
    ///  <returns><c>True</c> if the map owns the keys; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored keys. The value of this property has effect only
    ///  if the keys are objects, otherwise it is ignored.</remarks>
    property OwnsKeys: Boolean read GetOwnsKeys write SetOwnsKeys;

    ///  <summary>Specifies whether this map owns the values.</summary>
    ///  <returns><c>True</c> if the map owns the values; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored values. The value of this property has effect only
    ///  if the values are objects, otherwise it is ignored.</remarks>
    property OwnsValues: Boolean read GetOwnsValues write SetOwnsValues;
  end;

type
  ///  <summary>The generic <c>multi map</c> collection.</summary>
  ///  <remarks>This type uses a <c>dictionary</c> and a number of <c>sets</c> to store its
  ///  keys and values.</remarks>
  TDistinctMultiMap<TKey, TValue> = class(TAbstractDistinctMultiMap<TKey, TValue>)
  private
    FInitialCapacity: NativeUInt;

  protected
    ///  <summary>Called when the map needs to initialize its internal dictionary.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <remarks>This method creates a hash-based dictionary used as the underlying back-end for the map.</remarks>
    function CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, ISet<TValue>>; override;

    ///  <summary>Called when the map needs to initialize a set assoiated with a key.</summary>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a hash-based set. This set is associated with a key and store the map's
    ///  values for that key.</remarks>
    function CreateSet(const AValueType: IType<TValue>): ISet<TValue>; override;

    ///  <summary>Called when the serialization process is about to begin.</summary>
    ///  <param name="AData">The serialization data exposing the context and other serialization options.</param>
    procedure StartSerializing(const AData: TSerializationData); override;

    ///  <summary>Called when the deserialization process is about to begin.</summary>
    ///  <param name="AData">The deserialization data exposing the context and other deserialization options.</param>
    ///  <exception cref="DeHL.Exceptions|ESerializationException">Default implementation.</exception>
    procedure StartDeserializing(const AData: TDeserializationData); override;

    ///  <summary>Called when the an pair has been deserialized and needs to be inserted into the map.</summary>
    ///  <param name="AKey">The key that was deserialized.</param>
    ///  <param name="AValue">The value that was deserialized.</param>
    ///  <remarks>This method simply adds the element to the map.</remarks>
    procedure DeserializePair(const AKey: TKey; const AValue: TValue); override;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The map's initial capacity.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AInitialCapacity: NativeUInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AInitialCapacity">The map's initial capacity.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>; const AInitialCapacity: NativeUInt); overload;
  end;

  ///  <summary>The generic <c>multi map</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses a <c>dictionary</c> and a number of <c>sets</c> to store its
  ///  keys and values.</remarks>
  TObjectDistinctMultiMap<TKey, TValue> = class(TDistinctMultiMap<TKey, TValue>)
  private
    FKeyWrapperType: TMaybeObjectWrapperType<TKey>;
    FValueWrapperType: TMaybeObjectWrapperType<TValue>;

    { Getters/Setters for OwnsKeys }
    function GetOwnsKeys: Boolean;
    procedure SetOwnsKeys(const Value: Boolean);

    { Getters/Setters for OwnsValues }
    function GetOwnsValues: Boolean;
    procedure SetOwnsValues(const Value: Boolean);

  protected
    ///  <summary>Installs the type objects describing the key and the value or the stored pairs.</summary>
    ///  <param name="AKeyType">The key's type object to install.</param>
    ///  <param name="AValueType">The value's type object to install.</param>
    ///  <remarks>This method installs a custom wrapper designed to suppress the cleanup of objects on request.
    ///  Make sure to call this method in descendant classes.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    procedure InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); override;

  public
    ///  <summary>Specifies whether this map owns the keys.</summary>
    ///  <returns><c>True</c> if the map owns the keys; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored keys. The value of this property has effect only
    ///  if the keys are objects, otherwise it is ignored.</remarks>
    property OwnsKeys: Boolean read GetOwnsKeys write SetOwnsKeys;

    ///  <summary>Specifies whether this map owns the values.</summary>
    ///  <returns><c>True</c> if the map owns the values; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored values. The value of this property has effect only
    ///  if the values are objects, otherwise it is ignored.</remarks>
    property OwnsValues: Boolean read GetOwnsValues write SetOwnsValues;
  end;

type
  { Multi-Map based on a sorted dictionary and a list }
  TSortedDistinctMultiMap<TKey, TValue> = class(TAbstractDistinctMultiMap<TKey, TValue>)
  private
    FAscSort: Boolean;

  protected
    { Provide our implementations }
    function CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, ISet<TValue>>; override;
    function CreateSet(const AValueType: IType<TValue>): ISet<TValue>; override;

    { Serialization overrides }
    procedure StartSerializing(const AData: TSerializationData); override;
    procedure StartDeserializing(const AData: TDeserializationData); override;
    procedure DeserializePair(const AKey: TKey; const AValue: TValue); override;
  public
    { Constructors }
    constructor Create(const Ascending: Boolean = true); overload;
    constructor Create(const AEnumerable: IEnumerable<KVPair<TKey,TValue>>; const Ascending: Boolean = true); overload;
    constructor Create(const AArray: array of KVPair<TKey,TValue>; const Ascending: Boolean = true); overload;
    constructor Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>; const Ascending: Boolean = true); overload;
    constructor Create(const AArray: TFixedArray<KVPair<TKey, TValue>>; const Ascending: Boolean = true); overload;

    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>; const Ascending: Boolean = true); overload;
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AEnumerable : IEnumerable<KVPair<TKey,TValue>>; const Ascending: Boolean = true); overload;
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray : array of KVPair<TKey,TValue>; const Ascending: Boolean = true); overload;
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray : TDynamicArray<KVPair<TKey,TValue>>; const Ascending: Boolean = true); overload;
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray : TFixedArray<KVPair<TKey,TValue>>; const Ascending: Boolean = true); overload;

    { Enex - Associative collection }
    function MaxKey(): TKey; override;
    function MinKey(): TKey; override;
  end;

  { The object variant }
  TObjectSortedDistinctMultiMap<TKey, TValue> = class(TSortedDistinctMultiMap<TKey, TValue>)
  private
    FKeyWrapperType: TMaybeObjectWrapperType<TKey>;
    FValueWrapperType: TMaybeObjectWrapperType<TValue>;

    { Getters/Setters for OwnsKeys }
    function GetOwnsKeys: Boolean;
    procedure SetOwnsKeys(const Value: Boolean);

    { Getters/Setters for OwnsValues }
    function GetOwnsValues: Boolean;
    procedure SetOwnsValues(const Value: Boolean);

  protected
    { Override in descendants to Type proper stuff }
    procedure InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); override;

  public

    { Object owning }
    property OwnsKeys: Boolean read GetOwnsKeys write SetOwnsKeys;
    property OwnsValues: Boolean read GetOwnsValues write SetOwnsValues;
  end;

type
  ///  <summary>The generic <c>multi map</c> collection.</summary>
  ///  <remarks>This type uses a <c>sorted dictionary</c> and a number of <c>sorted lists</c> to store its
  ///  keys and values.</remarks>
  TDoubleSortedMultiMap<TKey, TValue> = class(TSortedMultiMap<TKey, TValue>)
  private
    FAscValues: Boolean;

  protected
    ///  <summary>Called when the map needs to initialize a list assoiated with a key.</summary>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a simple array-based sorted list. This list is associated with a key and store the map's
    ///  values for that key.</remarks>
    function CreateList(const AValueType: IType<TValue>): IList<TValue>; override;

    ///  <summary>Called when the serialization process is about to begin.</summary>
    ///  <param name="AData">The serialization data exposing the context and other serialization options.</param>
    procedure StartSerializing(const AData: TSerializationData); override;

    ///  <summary>Called when the deserialization process is about to begin.</summary>
    ///  <param name="AData">The deserialization data exposing the context and other deserialization options.</param>
    ///  <exception cref="DeHL.Exceptions|ESerializationException">Default implementation.</exception>
    procedure StartDeserializing(const AData: TDeserializationData); override;

    ///  <summary>Called when the an pair has been deserialized and needs to be inserted into the map.</summary>
    ///  <param name="AKey">The key that was deserialized.</param>
    ///  <param name="AValue">The value that was deserialized.</param>
    ///  <remarks>This method simply adds the element to the map.</remarks>
    procedure DeserializePair(const AKey: TKey; const AValue: TValue); override;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    constructor Create(const ACollection: IEnumerable<KVPair<TKey,TValue>>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of KVPair<TKey,TValue>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TFixedArray<KVPair<TKey, TValue>>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="ACollection">A collection to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const ACollection: IEnumerable<KVPair<TKey,TValue>>; const AAscendingKeys: Boolean = true;
      const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: array of KVPair<TKey,TValue>; const AAscendingKeys: Boolean = true;
      const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: TDynamicArray<KVPair<TKey,TValue>>; const AAscendingKeys: Boolean = true;
      const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: TFixedArray<KVPair<TKey,TValue>>; const AAscendingKeys: Boolean = true;
      const AAscendingValues: Boolean = true); overload;
  end;

  ///  <summary>The generic <c>multi map</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses a <c>sorted dictionary</c> and a number of <c>sorted lists</c> to store its
  ///  keys and values.</remarks>
  TObjectDoubleSortedMultiMap<TKey, TValue> = class(TDoubleSortedMultiMap<TKey, TValue>)
  private
    FKeyWrapperType: TMaybeObjectWrapperType<TKey>;
    FValueWrapperType: TMaybeObjectWrapperType<TValue>;

    { Getters/Setters for OwnsKeys }
    function GetOwnsKeys: Boolean;
    procedure SetOwnsKeys(const Value: Boolean);

    { Getters/Setters for OwnsValues }
    function GetOwnsValues: Boolean;
    procedure SetOwnsValues(const Value: Boolean);

  protected
    ///  <summary>Installs the type objects describing the key and the value or the stored pairs.</summary>
    ///  <param name="AKeyType">The key's type object to install.</param>
    ///  <param name="AValueType">The value's type object to install.</param>
    ///  <remarks>This method installs a custom wrapper designed to suppress the cleanup of objects on request.
    ///  Make sure to call this method in descendant classes.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    procedure InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); override;

  public
    ///  <summary>Specifies whether this map owns the keys.</summary>
    ///  <returns><c>True</c> if the map owns the keys; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored keys. The value of this property has effect only
    ///  if the keys are objects, otherwise it is ignored.</remarks>
    property OwnsKeys: Boolean read GetOwnsKeys write SetOwnsKeys;

    ///  <summary>Specifies whether this map owns the values.</summary>
    ///  <returns><c>True</c> if the map owns the values; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored values. The value of this property has effect only
    ///  if the values are objects, otherwise it is ignored.</remarks>
    property OwnsValues: Boolean read GetOwnsValues write SetOwnsValues;
  end;

type
  ///  <summary>The generic <c>multi map</c> collection.</summary>
  ///  <remarks>This type uses a <c>sorted dictionary</c> and a number of <c>sorted sets</c> to store its
  ///  keys and values.</remarks>
  TDoubleSortedDistinctMultiMap<TKey, TValue> = class(TSortedDistinctMultiMap<TKey, TValue>)
  private
    FAscValues: Boolean;

  protected
    ///  <summary>Called when the map needs to initialize a set assoiated with a key.</summary>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates an AVL-based set. This set is associated with a key and store the map's
    ///  values for that key.</remarks>
    function CreateSet(const AValueType: IType<TValue>): ISet<TValue>; override;

    ///  <summary>Called when the serialization process is about to begin.</summary>
    ///  <param name="AData">The serialization data exposing the context and other serialization options.</param>
    procedure StartSerializing(const AData: TSerializationData); override;

    ///  <summary>Called when the deserialization process is about to begin.</summary>
    ///  <param name="AData">The deserialization data exposing the context and other deserialization options.</param>
    ///  <exception cref="DeHL.Exceptions|ESerializationException">Default implementation.</exception>
    procedure StartDeserializing(const AData: TDeserializationData); override;

    ///  <summary>Called when the an pair has been deserialized and needs to be inserted into the map.</summary>
    ///  <param name="AKey">The key that was deserialized.</param>
    ///  <param name="AValue">The value that was deserialized.</param>
    ///  <remarks>This method simply adds the element to the map.</remarks>
    procedure DeserializePair(const AKey: TKey; const AValue: TValue); override;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    constructor Create(const ACollection: IEnumerable<KVPair<TKey,TValue>>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of KVPair<TKey,TValue>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: TFixedArray<KVPair<TKey, TValue>>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AAscendingKeys: Boolean = true; const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="ACollection">A collection to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const ACollection: IEnumerable<KVPair<TKey,TValue>>; const AAscendingKeys: Boolean = true;
      const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: array of KVPair<TKey,TValue>; const AAscendingKeys: Boolean = true;
      const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: TDynamicArray<KVPair<TKey,TValue>>; const AAscendingKeys: Boolean = true;
      const AAscendingValues: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscendingKeys">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <param name="AAscendingValues">A value specifying whether the values are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
      const AArray: TFixedArray<KVPair<TKey,TValue>>; const AAscendingKeys: Boolean = true;
      const AAscendingValues: Boolean = true); overload;
  end;

  ///  <summary>The generic <c>multi map</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses a <c>sorted dictionary</c> and a number of <c>sorted sets</c> to store its
  ///  keys and values.</remarks>
  TObjectDoubleSortedDistinctMultiMap<TKey, TValue> = class(TDoubleSortedDistinctMultiMap<TKey, TValue>)
  private
    FKeyWrapperType: TMaybeObjectWrapperType<TKey>;
    FValueWrapperType: TMaybeObjectWrapperType<TValue>;

    { Getters/Setters for OwnsKeys }
    function GetOwnsKeys: Boolean;
    procedure SetOwnsKeys(const Value: Boolean);

    { Getters/Setters for OwnsValues }
    function GetOwnsValues: Boolean;
    procedure SetOwnsValues(const Value: Boolean);

  protected
    ///  <summary>Installs the type objects describing the key and the value or the stored pairs.</summary>
    ///  <param name="AKeyType">The key's type object to install.</param>
    ///  <param name="AValueType">The value's type object to install.</param>
    ///  <remarks>This method installs a custom wrapper designed to suppress the cleanup of objects on request.
    ///  Make sure to call this method in descendant classes.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    procedure InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); override;

  public
    ///  <summary>Specifies whether this map owns the keys.</summary>
    ///  <returns><c>True</c> if the map owns the keys; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored keys. The value of this property has effect only
    ///  if the keys are objects, otherwise it is ignored.</remarks>
    property OwnsKeys: Boolean read GetOwnsKeys write SetOwnsKeys;

    ///  <summary>Specifies whether this map owns the values.</summary>
    ///  <returns><c>True</c> if the map owns the values; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the map controls the life-time of the stored values. The value of this property has effect only
    ///  if the values are objects, otherwise it is ignored.</remarks>
    property OwnsValues: Boolean read GetOwnsValues write SetOwnsValues;
  end;

implementation


{ TAbstractMultiMap<TKey, TValue> }

procedure TAbstractMultiMap<TKey, TValue>.Add(const APair: KVPair<TKey, TValue>);
begin
  { Call the other add }
  Add(APair.Key, APair.Value);
end;

procedure TAbstractMultiMap<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue);
var
  List: IList<TValue>;
begin
  { Try to look-up what we need. Create a new list and add it if required. }
  if not FDictionary.TryGetValue(AKey, List) then
  begin
    List := CreateList(FValueType);
    FDictionary[AKey] := List;
  end;

  { Add the new element to the list }
  List.Add(AValue);

  { Increase the version }
  Inc(FKnownCount);
  Inc(FVer);
end;

procedure TAbstractMultiMap<TKey, TValue>.Clear;
var
  List: IList<TValue>;
begin
  if (FDictionary <> nil) then
    { Simply clear out the dictionary }
    FDictionary.Clear();

  { Increase the version }
  FKnownCount := 0;
  Inc(FVer);
end;

function TAbstractMultiMap<TKey, TValue>.ContainsKey(const AKey: TKey): Boolean;
begin
  { Delegate to the dictionary object }
  Result := FDictionary.ContainsKey(AKey);
end;

function TAbstractMultiMap<TKey, TValue>.ContainsValue(const AKey: TKey; const AValue: TValue): Boolean;
var
  List: IList<TValue>;
begin
  { Try to find .. otherwise fail! }
  if FDictionary.TryGetValue(AKey, List) then
    Result := List.Contains(AValue)
  else
    Result := false;
end;

function TAbstractMultiMap<TKey, TValue>.ContainsValue(const APair: KVPair<TKey, TValue>): Boolean;
begin
  { Call upper function }
  Result := ContainsValue(APair.Key, APair.Value);
end;

function TAbstractMultiMap<TKey, TValue>.ContainsValue(const AValue: TValue): Boolean;
var
  List: IList<TValue>;
begin
  { Iterate over the dictionary }
  for List in FDictionary.Values do
  begin
    { Is there anything there? }
    if List.Contains(AValue) then
      Exit(true);
  end;

  { Nothing found }
  Result := false;
end;

procedure TAbstractMultiMap<TKey, TValue>.CopyTo(var AArray: array of KVPair<TKey, TValue>; const AStartIndex: NativeUInt);
var
  Key: TKey;
  List: IList<TValue>;
  X, I: NativeUInt;
begin
  { Check for indexes }
  if AStartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (NativeUInt(Length(AArray)) - AStartIndex) < Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;

  { Iterate over all lists and copy thtm to array }
  for Key in FDictionary.Keys do
  begin
    List := FDictionary[Key];

    if List.Count > 0 then
      for I := 0 to List.Count - 1 do
        AArray[X + I] := KVPair.Create<TKey, TValue>(Key, List[I]);

    Inc(X, List.Count);
  end;
end;

constructor TAbstractMultiMap<TKey, TValue>.Create;
begin
  Create(TType<TKey>.Default, TType<TValue>.Default);
end;

constructor TAbstractMultiMap<TKey, TValue>.Create(
  const ACollection: IEnumerable<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, ACollection);
end;

constructor TAbstractMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>);
begin
  { Initialize instance }
  if (AKeyType = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AKeyType');

  if (AValueType = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AValueType');

  { Insatll the types }
  InstallTypes(AKeyType, AValueType);

  { Create the dictionary }
  FDictionary := CreateDictionary(KeyType);

  FKeyCollection := TKeyCollection.Create(Self);
  FValueCollection := TValueCollection.Create(Self);

  { Create an internal empty list }
  FEmptyList := CreateList(ValueType);

  FKnownCount := 0;
  FVer := 0;
end;

constructor TAbstractMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const ACollection: IEnumerable<KVPair<TKey, TValue>>);
var
  V: KVPair<TKey, TValue>;
begin
  { Call upper constructor }
  Create(AKeyType, AValueType);

  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Pump in all items }
  for V in ACollection do
  begin
{$IFNDEF BUG_GENERIC_INCOMPAT_TYPES}
    Add(V);
{$ELSE}
    Add(V.Key, V.Value);
{$ENDIF}
  end;
end;

constructor TAbstractMultiMap<TKey, TValue>.Create(
  const AArray: array of KVPair<TKey, TValue>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: array of KVPair<TKey, TValue>);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(AKeyType, AValueType);

  { Copy all items in }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;


constructor TAbstractMultiMap<TKey, TValue>.Create(const AArray: TFixedArray<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractMultiMap<TKey, TValue>.Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TFixedArray<KVPair<TKey, TValue>>);
var
  I: NativeUInt;
begin
  { Call upper constructor }
  Create(AKeyType, AValueType);

  { Copy all items in }
  if AArray.Length > 0 then
    for I := 0 to AArray.Length - 1 do
    begin
{$IFNDEF BUG_GENERIC_INCOMPAT_TYPES}
      Add(AArray[I]);
{$ELSE}
      Add(AArray[I].Key, AArray[I].Value);
{$ENDIF}
    end;
end;

constructor TAbstractMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TDynamicArray<KVPair<TKey, TValue>>);
var
  I: NativeUInt;
begin
  { Call upper constructor }
  Create(AKeyType, AValueType);

  { Copy all items in }
  if AArray.Length > 0 then
    for I := 0 to AArray.Length - 1 do
    begin
{$IFNDEF BUG_GENERIC_INCOMPAT_TYPES}
      Add(AArray[I]);
{$ELSE}
      Add(AArray[I].Key, AArray[I].Value);
{$ENDIF}
    end;
end;


destructor TAbstractMultiMap<TKey, TValue>.Destroy;
begin
  { Clear first }
  Clear();

  inherited;
end;

function TAbstractMultiMap<TKey, TValue>.GetCount: NativeUInt;
begin
  Result := FKnownCount;
end;

function TAbstractMultiMap<TKey, TValue>.GetEnumerator: IEnumerator<KVPair<TKey, TValue>>;
begin
  Result := TPairEnumerator.Create(Self);
end;

function TAbstractMultiMap<TKey, TValue>.GetItemList(const AKey: TKey): IEnexIndexedCollection<TValue>;
var
  List: IList<TValue>;
begin
  if not FDictionary.TryGetValue(AKey, List) then
    ExceptionHelper.Throw_KeyNotFoundError('AKey');

  Result := List;
end;

function TAbstractMultiMap<TKey, TValue>.KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean;
begin
  Result := ContainsValue(AKey, AValue);
end;

procedure TAbstractMultiMap<TKey, TValue>.Remove(const AKey: TKey; const AValue: TValue);
var
  List: IList<TValue>;
begin
  { Simply remove the value from the list at key }
  if FDictionary.TryGetValue(AKey, List) then
  begin
    if List.Contains(AValue) then
    begin
      List.Remove(AValue);

      { Kill the list for one element }
      if List.Count = 0 then
        FDictionary.Remove(AKey);

      Dec(FKnownCount, 1);

      { Increase the version }
      Inc(FVer);
    end;
  end;
end;

procedure TAbstractMultiMap<TKey, TValue>.Remove(const APair: KVPair<TKey, TValue>);
begin
  { Call upper function }
  Remove(APair.Key, APair.Value);
end;

function TAbstractMultiMap<TKey, TValue>.SelectKeys: IEnexCollection<TKey>;
begin
  Result := Keys;
end;

function TAbstractMultiMap<TKey, TValue>.SelectValues: IEnexCollection<TValue>;
begin
  Result := Values;
end;

function TAbstractMultiMap<TKey, TValue>.TryGetValues(const AKey: TKey): IEnexIndexedCollection<TValue>;
begin
  if not TryGetValues(AKey, Result) then
    Result := FEmptyList;
end;

function TAbstractMultiMap<TKey, TValue>.TryGetValues(const AKey: TKey;
  out AValues: IEnexIndexedCollection<TValue>): Boolean;
var
  LList: IList<TValue>;
begin
  { Use the internal stuff }
  Result := FDictionary.TryGetValue(AKey, LList);

  if Result then
    AValues := LList;
end;

function TAbstractMultiMap<TKey, TValue>.ValueForKey(const AKey: TKey): TValue;
begin
  Result := GetItemList(AKey)[0];
end;

procedure TAbstractMultiMap<TKey, TValue>.Remove(const AKey: TKey);
var
  List: IList<TValue>;
begin
  if FDictionary.TryGetValue(AKey, List) then
    Dec(FKnownCount, List.Count);

  { Simply remove the element. The list should be auto-magically collected also }
  FDictionary.Remove(AKey);

  { Increase the version }
  Inc(FVer);
end;

{ TAbstractMultiMap<TKey, TValue>.TPairEnumerator }

constructor TAbstractMultiMap<TKey, TValue>.TPairEnumerator.Create(const ADict: TAbstractMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FVer := ADict.FVer;

  { Get the enumerator }
  FListIndex := 0;
  FDictEnum := FDict.FDictionary.GetEnumerator();
  FList := nil;
end;

destructor TAbstractMultiMap<TKey, TValue>.TPairEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TAbstractMultiMap<TKey, TValue>.TPairEnumerator.GetCurrent: KVPair<TKey,TValue>;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TAbstractMultiMap<TKey, TValue>.TPairEnumerator.MoveNext: Boolean;
begin
  { Repeat until something happens }
  while True do
  begin
    if FVer <> FDict.FVer then
       ExceptionHelper.Throw_CollectionChangedError();

    { We're still in the same KV? }
    if (FList <> nil) and (FListIndex < FList.Count) then
    begin
      { Next element }
      FValue := KVPair<TKey, TValue>.Create(FDictEnum.Current.Key, FList[FListIndex]);

      Inc(FListIndex);
      Result := true;

      Exit;
    end;

    { Get the next KV pair from the dictionary }
    Result := FDictEnum.MoveNext();
    if not Result then
    begin
      FList := nil;
      Exit;
    end;

    { Reset the list }
    FListIndex := 0;
    FList := FDictEnum.Current.Value;
  end;
end;

{ TAbstractMultiMap<TKey, TValue>.TKeyEnumerator }

constructor TAbstractMultiMap<TKey, TValue>.TKeyEnumerator.Create(const ADict: TAbstractMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FVer := ADict.FVer;
  FValue := default(TKey);

  { Create enumerator }
  FDictEnum := FDict.FDictionary.Keys.GetEnumerator();
end;

destructor TAbstractMultiMap<TKey, TValue>.TKeyEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TAbstractMultiMap<TKey, TValue>.TKeyEnumerator.GetCurrent: TKey;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TAbstractMultiMap<TKey, TValue>.TKeyEnumerator.MoveNext: Boolean;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  { Move next and get the value }
  Result := FDictEnum.MoveNext();
  if Result then
    FValue := FDictEnum.Current;
end;


{ TAbstractMultiMap<TKey, TValue>.TValueEnumerator }

constructor TAbstractMultiMap<TKey, TValue>.TValueEnumerator.Create(const ADict: TAbstractMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FVer := ADict.FVer;

  { Get the enumerator }
  FListIndex := 0;
  FDictEnum := FDict.FDictionary.Values.GetEnumerator();
  FList := nil;
end;

destructor TAbstractMultiMap<TKey, TValue>.TValueEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TAbstractMultiMap<TKey, TValue>.TValueEnumerator.GetCurrent: TValue;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TAbstractMultiMap<TKey, TValue>.TValueEnumerator.MoveNext: Boolean;
begin
  { Repeat until something happens }
  while True do
  begin
    if FVer <> FDict.FVer then
       ExceptionHelper.Throw_CollectionChangedError();

    { We're still in the same KV? }
    if (FList <> nil) and (FListIndex < FList.Count) then
    begin
      { Next element }
      FValue := FList[FListIndex];

      Inc(FListIndex);
      Result := true;

      Exit;
    end;

    { Get the next KV pair from the dictionary }
    Result := FDictEnum.MoveNext();
    if not Result then
    begin
      FList := nil;
      Exit;
    end;

    { Reset the list }
    FListIndex := 0;
    FList := FDictEnum.Current;
  end;
end;

{ TAbstractMultiMap<TKey, TValue>.TKeyCollection }

constructor TAbstractMultiMap<TKey, TValue>.TKeyCollection.Create(const ADict: TAbstractMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;

  InstallType(ADict.KeyType);
end;

destructor TAbstractMultiMap<TKey, TValue>.TKeyCollection.Destroy;
begin
  inherited;
end;

function TAbstractMultiMap<TKey, TValue>.TKeyCollection.Empty: Boolean;
begin
  Result := (FDict.FDictionary.Count = 0);
end;

function TAbstractMultiMap<TKey, TValue>.TKeyCollection.GetCount: NativeUInt;
begin
  { Number of elements is the same as key }
  Result := FDict.FDictionary.Count;
end;

function TAbstractMultiMap<TKey, TValue>.TKeyCollection.GetEnumerator: IEnumerator<TKey>;
begin
  Result := TKeyEnumerator.Create(Self.FDict);
end;

procedure TAbstractMultiMap<TKey, TValue>.TKeyCollection.CopyTo(var AArray: array of TKey; const StartIndex: NativeUInt);
begin
  { Check for indexes }
  if StartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('StartIndex');

  if (NativeUInt(Length(AArray)) - StartIndex) < FDict.FDictionary.Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  { Simply copy using the dictionary provided methods }
  FDict.FDictionary.Keys.CopyTo(AArray, StartIndex);
end;

{ TAbstractMultiMap<TKey, TValue>.TValueCollection }

constructor TAbstractMultiMap<TKey, TValue>.TValueCollection.Create(const ADict: TAbstractMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;

  InstallType(ADict.ValueType);
end;

destructor TAbstractMultiMap<TKey, TValue>.TValueCollection.Destroy;
begin
  inherited;
end;

function TAbstractMultiMap<TKey, TValue>.TValueCollection.Empty: Boolean;
begin
  Result := (FDict.FDictionary.Count = 0);
end;

function TAbstractMultiMap<TKey, TValue>.TValueCollection.GetCount: NativeUInt;
begin
  { Number of elements is different use the count provided by the dictionary }
  Result := FDict.Count;
end;

function TAbstractMultiMap<TKey, TValue>.TValueCollection.GetEnumerator: IEnumerator<TValue>;
begin
  Result := TValueEnumerator.Create(Self.FDict);
end;

procedure TAbstractMultiMap<TKey, TValue>.TValueCollection.CopyTo(var AArray: array of TValue; const StartIndex: NativeUInt);
var
  List: IList<TValue>;
  X, I: NativeUInt;
begin
  { Check for indexes }
  if StartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('StartIndex');

  if (NativeUInt(Length(AArray)) - StartIndex) < FDict.Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := StartIndex;

  { Iterate over all lists and copy thtm to array }
  for List in FDict.FDictionary.Values do
  begin
    if List.Count > 0 then
      for I := 0 to List.Count - 1 do
        AArray[X + I] := List[I];

    Inc(X, List.Count);
  end;
end;



{ TAbstractDistinctMultiMap<TKey, TValue> }

procedure TAbstractDistinctMultiMap<TKey, TValue>.Add(const APair: KVPair<TKey, TValue>);
begin
  { Call the other add }
  Add(APair.Key, APair.Value);
end;

procedure TAbstractDistinctMultiMap<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue);
var
  LSet: ISet<TValue>;
begin
  { Try to look-up what we need. Create a new list and add it if required. }
  if not FDictionary.TryGetValue(AKey, LSet) then
  begin
    LSet := CreateSet(FValueType);
    FDictionary[AKey] := LSet;
  end;

  { Add the new element to the list }
  if not LSet.Contains(AValue) then
  begin
    LSet.Add(AValue);

    { Increase the version }
    Inc(FKnownCount);
    Inc(FVer);
  end;
end;

procedure TAbstractDistinctMultiMap<TKey, TValue>.Clear;
var
  List: IList<TValue>;
begin
  if (FDictionary <> nil) then
    { Simply clear out the dictionary }
    FDictionary.Clear();

  { Increase the version }
  FKnownCount := 0;
  Inc(FVer);
end;

function TAbstractDistinctMultiMap<TKey, TValue>.ContainsKey(const AKey: TKey): Boolean;
begin
  { Delegate to the dictionary object }
  Result := FDictionary.ContainsKey(AKey);
end;

function TAbstractDistinctMultiMap<TKey, TValue>.ContainsValue(const AKey: TKey; const AValue: TValue): Boolean;
var
  LSet: ISet<TValue>;
begin
  { Try to find .. otherwise fail! }
  if FDictionary.TryGetValue(AKey, LSet) then
    Result := LSet.Contains(AValue)
  else
    Result := false;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.ContainsValue(const APair: KVPair<TKey, TValue>): Boolean;
begin
  { Call upper function }
  Result := ContainsValue(APair.Key, APair.Value);
end;

function TAbstractDistinctMultiMap<TKey, TValue>.ContainsValue(const AValue: TValue): Boolean;
var
  LSet: ISet<TValue>;
begin
  { Iterate over the dictionary }
  for LSet in FDictionary.Values do
  begin
    { Is there anything there? }
    if LSet.Contains(AValue) then
      Exit(true);
  end;

  { Nothing found }
  Result := false;
end;

procedure TAbstractDistinctMultiMap<TKey, TValue>.CopyTo(
  var AArray: array of KVPair<TKey, TValue>; const AStartIndex: NativeUInt);
var
  Key: TKey;
  Value: TValue;
  LSet: ISet<TValue>;
  X: NativeUInt;
begin
  { Check for indexes }
  if AStartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (NativeUInt(Length(AArray)) - AStartIndex) < Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;

  { Iterate over all lists and copy thtm to array }
  for Key in FDictionary.Keys do
  begin
    LSet := FDictionary[Key];

    for Value in LSet do
    begin
      AArray[X] := KVPair.Create<TKey, TValue>(Key, Value);
      Inc(X);
    end;
  end;
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create;
begin
  Create(TType<TKey>.Default, TType<TValue>.Default);
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(
  const ACollection: IEnumerable<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, ACollection);
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>);
begin
  { Initialize instance }
  if (AKeyType = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AKeyType');

  if (AValueType = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AValueType');

  { Install the types }
  InstallTypes(AKeyType, AValueType);

  { Create the dictionary }
  FDictionary := CreateDictionary(KeyType);

  FKeyCollection := TKeyCollection.Create(Self);
  FValueCollection := TValueCollection.Create(Self);

  FEmptySet := CreateSet(ValueType);

  FKnownCount := 0;
  FVer := 0;
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const ACollection: IEnumerable<KVPair<TKey, TValue>>);
var
  V: KVPair<TKey, TValue>;
begin
  { Call upper constructor }
  Create(AKeyType, AValueType);

  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Pump in all items }
  for V in ACollection do
  begin
{$IFNDEF BUG_GENERIC_INCOMPAT_TYPES}
    Add(V);
{$ELSE}
    Add(V.Key, V.Value);
{$ENDIF}
  end;
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(
  const AArray: array of KVPair<TKey, TValue>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: array of KVPair<TKey, TValue>);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(AKeyType, AValueType);

  { Copy all items in }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;


constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(const AArray: TFixedArray<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TFixedArray<KVPair<TKey, TValue>>);
var
  I: NativeUInt;
begin
  { Call upper constructor }
  Create(AKeyType, AValueType);

  { Copy all items in }
  if AArray.Length > 0 then
    for I := 0 to AArray.Length - 1 do
    begin
{$IFNDEF BUG_GENERIC_INCOMPAT_TYPES}
      Add(AArray[I]);
{$ELSE}
      Add(AArray[I].Key, AArray[I].Value);
{$ENDIF}
    end;
end;

constructor TAbstractDistinctMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TDynamicArray<KVPair<TKey, TValue>>);
var
  I: NativeUInt;
begin
  { Call upper constructor }
  Create(AKeyType, AValueType);

  { Copy all items in }
  if AArray.Length > 0 then
    for I := 0 to AArray.Length - 1 do
    begin
{$IFNDEF BUG_GENERIC_INCOMPAT_TYPES}
      Add(AArray[I]);
{$ELSE}
      Add(AArray[I].Key, AArray[I].Value);
{$ENDIF}
    end;
end;

destructor TAbstractDistinctMultiMap<TKey, TValue>.Destroy;
begin
  { Clear first }
  Clear();

  inherited;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.GetCount: NativeUInt;
begin
  Result := FKnownCount;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.GetEnumerator: IEnumerator<KVPair<TKey, TValue>>;
begin
  Result := TPairEnumerator.Create(Self);
end;

function TAbstractDistinctMultiMap<TKey, TValue>.GetItemList(const AKey: TKey): IEnexCollection<TValue>;
var
  LSet: ISet<TValue>;
begin
  if not FDictionary.TryGetValue(AKey, LSet) then
    ExceptionHelper.Throw_KeyNotFoundError('AKey');

  Result := LSet;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean;
begin
  Result := ContainsValue(AKey, AValue);
end;

procedure TAbstractDistinctMultiMap<TKey, TValue>.Remove(const AKey: TKey; const AValue: TValue);
var
  LSet: ISet<TValue>;
begin
  { Simply remove the value from the list at key }
  if FDictionary.TryGetValue(AKey, LSet) then
  begin
    if LSet.Contains(AValue) then
    begin
      LSet.Remove(AValue);

      { Kill the list for one element }
      if LSet.Count = 0 then
        FDictionary.Remove(AKey);

      Dec(FKnownCount, 1);
    end;
  end;

  { Increase th version }
  Inc(FVer);
end;

procedure TAbstractDistinctMultiMap<TKey, TValue>.Remove(const APair: KVPair<TKey, TValue>);
begin
  { Call upper function }
  Remove(APair.Key, APair.Value);
end;

function TAbstractDistinctMultiMap<TKey, TValue>.SelectKeys: IEnexCollection<TKey>;
begin
  Result := Keys;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.SelectValues: IEnexCollection<TValue>;
begin
  Result := Values;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TryGetValues(
  const AKey: TKey): IEnexCollection<TValue>;
begin
  if not TryGetValues(AKey, Result) then
    Result := FEmptySet;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TryGetValues(const AKey: TKey;
  out AValues: IEnexCollection<TValue>): Boolean;
var
  LSet: ISet<TValue>;
begin
  { Use the internal stuff }
  Result := FDictionary.TryGetValue(AKey, LSet);

  if Result then
    AValues := LSet;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.ValueForKey(const AKey: TKey): TValue;
begin
  Result := GetItemList(AKey).First;
end;

procedure TAbstractDistinctMultiMap<TKey, TValue>.Remove(const AKey: TKey);
var
  LSet: ISet<TValue>;
begin
  if FDictionary.TryGetValue(AKey, LSet) then
    Dec(FKnownCount, LSet.Count);

  { Simply remove the element. The list should be auto-magically collected also }
  FDictionary.Remove(AKey);

  { Increase th version }
  Inc(FVer);
end;


{ TAbstractDistinctMultiMap<TKey, TValue>.TPairEnumerator }

constructor TAbstractDistinctMultiMap<TKey, TValue>.TPairEnumerator.Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FVer := ADict.FVer;

  { Get the enumerator }
  FDictEnum := FDict.FDictionary.GetEnumerator();
end;

destructor TAbstractDistinctMultiMap<TKey, TValue>.TPairEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TPairEnumerator.GetCurrent: KVPair<TKey,TValue>;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TPairEnumerator.MoveNext: Boolean;
begin
  { Repeat until something happens }
  while True do
  begin
    if FVer <> FDict.FVer then
       ExceptionHelper.Throw_CollectionChangedError();

    { We're still in the same KV? }
    if (FSetEnum <> nil) and (FSetEnum.MoveNext) then
    begin
      { Next element }
      FValue := KVPair.Create<TKey, TValue>(FDictEnum.Current.Key, FSetEnum.Current);
      Result := true;
      Exit;
    end;

    { Get the next KV pair from the dictionary }
    Result := FDictEnum.MoveNext();
    if not Result then
      Exit;

    { Reset the list }
    FSet := FDictEnum.Current.Value;
    FSetEnum := FSet.GetEnumerator();
  end;
end;

{ TAbstractDistinctMultiMap<TKey, TValue>.TKeyEnumerator }

constructor TAbstractDistinctMultiMap<TKey, TValue>.TKeyEnumerator.Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FVer := ADict.FVer;
  FValue := default(TKey);

  { Create enumerator }
  FDictEnum := FDict.FDictionary.Keys.GetEnumerator();
end;

destructor TAbstractDistinctMultiMap<TKey, TValue>.TKeyEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TKeyEnumerator.GetCurrent: TKey;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TKeyEnumerator.MoveNext: Boolean;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  { Move next and get the value }
  Result := FDictEnum.MoveNext();
  if Result then
    FValue := FDictEnum.Current;
end;


{ TAbstractDistinctMultiMap<TKey, TValue>.TValueEnumerator }

constructor TAbstractDistinctMultiMap<TKey, TValue>.TValueEnumerator.Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);
  FVer := ADict.FVer;

  { Get the enumerator }
  FDictEnum := FDict.FDictionary.Values.GetEnumerator();
end;

destructor TAbstractDistinctMultiMap<TKey, TValue>.TValueEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TValueEnumerator.GetCurrent: TValue;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TValueEnumerator.MoveNext: Boolean;
begin
  { Repeat until something happens }
  while True do
  begin
    if FVer <> FDict.FVer then
       ExceptionHelper.Throw_CollectionChangedError();

    { We're still in the same KV? }
    if (FSetEnum <> nil) and (FSetEnum.MoveNext()) then
    begin
      { Next element }
      FValue := FSetEnum.Current;

      Result := true;
      Exit;
    end;

    { Get the next KV pair from the dictionary }
    Result := FDictEnum.MoveNext();
    if not Result then
      Exit;

    { Reset the list }
    FSet := FDictEnum.Current;
    FSetEnum := FSet.GetEnumerator();
  end;
end;

{ TAbstractDistinctMultiMap<TKey, TValue>.TKeyCollection }

constructor TAbstractDistinctMultiMap<TKey, TValue>.TKeyCollection.Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;

  InstallType(ADict.KeyType);
end;

destructor TAbstractDistinctMultiMap<TKey, TValue>.TKeyCollection.Destroy;
begin
  inherited;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TKeyCollection.Empty: Boolean;
begin
  Result := (FDict.FDictionary.Count = 0);
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TKeyCollection.GetCount: NativeUInt;
begin
  { Number of elements is the same as key }
  Result := FDict.FDictionary.Count;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TKeyCollection.GetEnumerator: IEnumerator<TKey>;
begin
  Result := TKeyEnumerator.Create(Self.FDict);
end;

procedure TAbstractDistinctMultiMap<TKey, TValue>.TKeyCollection.CopyTo(var AArray: array of TKey; const StartIndex: NativeUInt);
begin
  { Check for indexes }
  if StartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('StartIndex');

  if (NativeUInt(Length(AArray)) - StartIndex) < FDict.FDictionary.Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  { Simply copy using the dictionary provided methods }
  FDict.FDictionary.Keys.CopyTo(AArray, StartIndex);
end;

{ TAbstractDistinctMultiMap<TKey, TValue>.TValueCollection }

constructor TAbstractDistinctMultiMap<TKey, TValue>.TValueCollection.Create(const ADict: TAbstractDistinctMultiMap<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;

  InstallType(ADict.ValueType);
end;

destructor TAbstractDistinctMultiMap<TKey, TValue>.TValueCollection.Destroy;
begin
  inherited;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TValueCollection.Empty: Boolean;
begin
  Result := (FDict.FDictionary.Count = 0);
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TValueCollection.GetCount: NativeUInt;
begin
  { Number of elements is different use the count provided by the dictionary }
  Result := FDict.Count;
end;

function TAbstractDistinctMultiMap<TKey, TValue>.TValueCollection.GetEnumerator: IEnumerator<TValue>;
begin
  Result := TValueEnumerator.Create(Self.FDict);
end;

procedure TAbstractDistinctMultiMap<TKey, TValue>.TValueCollection.CopyTo(var AArray: array of TValue; const StartIndex: NativeUInt);
var
  LSet: ISet<TValue>;
  Value: TValue;
  X: NativeUInt;
begin
  { Check for indexes }
  if StartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('StartIndex');

  if (NativeUInt(Length(AArray)) - StartIndex) < FDict.Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := StartIndex;

  { Iterate over all lists and copy thtm to array }
  for LSet in FDict.FDictionary.Values do
  begin
    for Value in LSet do
    begin
      AArray[X] := Value;
      Inc(X);
    end;
  end;
end;

const
  DefaultArrayLength = 32;

{ TMultiMap<TKey, TValue> }

constructor TMultiMap<TKey, TValue>.Create(const AInitialCapacity: NativeUInt);
begin
  FInitialCapacity := AInitialCapacity;
  inherited Create();
end;

constructor TMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>; const AInitialCapacity: NativeUInt);
begin
  FInitialCapacity := AInitialCapacity;
  inherited Create(AKeyType, AValueType);
end;

function TMultiMap<TKey, TValue>.CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, IList<TValue>>;
var
  Cap: NativeUInt;
begin
  { Create a simple dictionary }
  if FInitialCapacity = 0 then
    Cap := DefaultArrayLength
  else
    Cap := FInitialCapacity;

  Result := TDictionary<TKey, IList<TValue>>.Create(AKeyType, TType<IList<TValue>>.Default, Cap);
end;

function TMultiMap<TKey, TValue>.CreateList(const AValueType: IType<TValue>): IList<TValue>;
begin
  { Create a simple list }
  Result := TList<TValue>.Create(AValueType);
end;

{ TObjectMultiMap<TKey, TValue> }

procedure TObjectMultiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectMultiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectMultiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectMultiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectMultiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;

{ TSortedMultiMap<TKey, TValue> }

constructor TSortedMultiMap<TKey, TValue>.Create(
  const AArray: TDynamicArray<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AArray);
end;

constructor TSortedMultiMap<TKey, TValue>.Create(
  const AArray: TFixedArray<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AArray);
end;

constructor TSortedMultiMap<TKey, TValue>.Create(
  const AArray: array of KVPair<TKey, TValue>; const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AArray);
end;

constructor TSortedMultiMap<TKey, TValue>.Create(const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create();
end;

constructor TSortedMultiMap<TKey, TValue>.Create(
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(ACollection);
end;

constructor TSortedMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TDynamicArray<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TFixedArray<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: array of KVPair<TKey, TValue>; const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>; const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType);
end;

constructor TSortedMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType, ACollection);
end;

function TSortedMultiMap<TKey, TValue>.CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, IList<TValue>>;
begin
  { Create a simple dictionary }
  Result := TSortedDictionary<TKey, IList<TValue>>.Create(AKeyType, TType<IList<TValue>>.Default, FAscSort);
end;

function TSortedMultiMap<TKey, TValue>.CreateList(const AValueType: IType<TValue>): IList<TValue>;
begin
  { Create a simple list }
  Result := TList<TValue>.Create(AValueType);
end;

procedure TSortedMultiMap<TKey, TValue>.DeserializePair(const AKey: TKey; const AValue: TValue);
begin
  { Very simple }
  Add(AKey, AValue);
end;

function TSortedMultiMap<TKey, TValue>.MaxKey: TKey;
begin
  Result := Dictionary.MaxKey;
end;

function TSortedMultiMap<TKey, TValue>.MinKey: TKey;
begin
  Result := Dictionary.MinKey;
end;

procedure TSortedMultiMap<TKey, TValue>.StartDeserializing(const AData: TDeserializationData);
var
  LAsc: Boolean;
begin
  AData.GetValue(SSerAscendingKeys, LAsc);

  { Call the constructor in this instance to initialize myself first }
  Create(LAsc);
end;

procedure TSortedMultiMap<TKey, TValue>.StartSerializing(const AData: TSerializationData);
begin
  { Write the ascending sign }
  AData.AddValue(SSerAscendingKeys, FAscSort);
end;

{ TObjectSortedMultiMap<TKey, TValue> }

procedure TObjectSortedMultiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TMaybeObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TMaybeObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectSortedMultiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectSortedMultiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectSortedMultiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectSortedMultiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;


const
  DefaultArrayLength = 32;

{ TDistinctMultiMap<TKey, TValue> }

constructor TDistinctMultiMap<TKey, TValue>.Create(const AInitialCapacity: NativeUInt);
begin
  FInitialCapacity := AInitialCapacity;
  inherited Create();
end;

constructor TDistinctMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>; const AInitialCapacity: NativeUInt);
begin
  FInitialCapacity := AInitialCapacity;
  inherited Create(AKeyType, AValueType);
end;

function TDistinctMultiMap<TKey, TValue>.CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, ISet<TValue>>;
var
  Cap: NativeUInt;
begin
  { Create a simple dictionary }
  if FInitialCapacity = 0 then
    Cap := DefaultArrayLength
  else
    Cap := FInitialCapacity;

  Result := TDictionary<TKey, ISet<TValue>>.Create(AKeyType, TType<ISet<TValue>>.Default, Cap);
end;

function TDistinctMultiMap<TKey, TValue>.CreateSet(const AValueType: IType<TValue>): ISet<TValue>;
begin
  { Create a simple list }
  Result := THashSet<TValue>.Create(AValueType);
end;

procedure TDistinctMultiMap<TKey, TValue>.DeserializePair(const AKey: TKey; const AValue: TValue);
begin
  { Very simple }
  Add(AKey, AValue);
end;

procedure TDistinctMultiMap<TKey, TValue>.StartDeserializing(const AData: TDeserializationData);
begin
  { Call the constructor in this instance to initialize myself first }
  Create();
end;

procedure TDistinctMultiMap<TKey, TValue>.StartSerializing(const AData: TSerializationData);
begin
  // Do nothing, just say that I am here and I can be serialized
end;

{ TObjectDistinctMultiMap<TKey, TValue> }

procedure TObjectDistinctMultiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TMaybeObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TMaybeObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectDistinctMultiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectDistinctMultiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectDistinctMultiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectDistinctMultiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;


{ TSortedDistinctMultiMap<TKey, TValue> }

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(
  const AArray: TDynamicArray<KVPair<TKey, TValue>>;
  const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AArray);
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(
  const AArray: TFixedArray<KVPair<TKey, TValue>>;
  const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AArray);
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(
  const AArray: array of KVPair<TKey, TValue>; const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AArray);
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create();
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(
  const AEnumerable: IEnumerable<KVPair<TKey, TValue>>;
  const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AEnumerable);
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TDynamicArray<KVPair<TKey, TValue>>;
  const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TFixedArray<KVPair<TKey, TValue>>;
  const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: array of KVPair<TKey, TValue>; const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>; const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AKeyType, AValueType);
end;

constructor TSortedDistinctMultiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AEnumerable: IEnumerable<KVPair<TKey, TValue>>;
  const Ascending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := Ascending;
  inherited Create(AKeyType, AValueType, AEnumerable);
end;

function TSortedDistinctMultiMap<TKey, TValue>.CreateDictionary(const AKeyType: IType<TKey>): IDictionary<TKey, ISet<TValue>>;
begin
  { Create a simple dictionary }
  Result := TSortedDictionary<TKey, ISet<TValue>>.Create(AKeyType, TType<ISet<TValue>>.Default, FAscSort);
end;

function TSortedDistinctMultiMap<TKey, TValue>.CreateSet(const AValueType: IType<TValue>): ISet<TValue>;
begin
  { Create a simple list }
  Result := THashSet<TValue>.Create(AValueType);
end;

procedure TSortedDistinctMultiMap<TKey, TValue>.DeserializePair(const AKey: TKey; const AValue: TValue);
begin
  { Very simple }
  Add(AKey, AValue);
end;

function TSortedDistinctMultiMap<TKey, TValue>.MaxKey: TKey;
begin
  Result := Dictionary.MaxKey;
end;

function TSortedDistinctMultiMap<TKey, TValue>.MinKey: TKey;
begin
  Result := Dictionary.MinKey;
end;

procedure TSortedDistinctMultiMap<TKey, TValue>.StartDeserializing(const AData: TDeserializationData);
var
  LAsc: Boolean;
begin
  { Try to obtain the ascending sign }
  AData.GetValue(SSerAscendingKeys, LAsc);

  { Call the constructor in this instance to initialize myself first }
  Create(LAsc);
end;

procedure TSortedDistinctMultiMap<TKey, TValue>.StartSerializing(const AData: TSerializationData);
begin
  { Write the ascending sign }
  AData.AddValue(SSerAscendingKeys, FAscSort);
end;

{ TObjectSortedDistinctMultiMap<TKey, TValue> }

procedure TObjectSortedDistinctMultiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TMaybeObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TMaybeObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectSortedDistinctMultiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectSortedDistinctMultiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectSortedDistinctMultiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectSortedDistinctMultiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;


{ TDoubleSortedMultiMap<TKey, TValue> }

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const AArray: TDynamicArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AArray, AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const AArray: TFixedArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AArray, AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const AArray: array of KVPair<TKey, TValue>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AArray, AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(ACollection, AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: TDynamicArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, AArray, AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: TFixedArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, AArray, AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: array of KVPair<TKey, TValue>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, AArray, AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, AAscendingKeys);
end;

constructor TDoubleSortedMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, ACollection, AAscendingKeys);
end;

function TDoubleSortedMultiMap<TKey, TValue>.CreateList(const AValueType: IType<TValue>): IList<TValue>;
begin
  { Create a simple list }
  Result := TSortedList<TValue>.Create(AValueType, FAscValues);
end;

procedure TDoubleSortedMultiMap<TKey, TValue>.DeserializePair(const AKey: TKey; const AValue: TValue);
begin
  { Write the ascending sign }
  Add(AKey, AValue);
end;

procedure TDoubleSortedMultiMap<TKey, TValue>.StartDeserializing(const AData: TDeserializationData);
var
  LAscKeys, LAscValues: Boolean;
begin
  { Try to obtain the ascending sign }
  AData.GetValue(SSerAscendingKeys, LAscKeys);
  AData.GetValue(SSerAscendingValues, LAscValues);

  { Call the constructor in this instance to initialize myself first }
  Create(LAscKeys, LAscValues);
end;

procedure TDoubleSortedMultiMap<TKey, TValue>.StartSerializing(const AData: TSerializationData);
begin
  inherited;

  { Write the ascending sign }
  AData.AddValue(SSerAscendingValues, FAscValues);
end;

{ TObjectDoubleSortedMultiMap<TKey, TValue> }

procedure TObjectDoubleSortedMultiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TMaybeObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TMaybeObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectDoubleSortedMultiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectDoubleSortedMultiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectDoubleSortedMultiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectDoubleSortedMultiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;


{ TDoubleSortedDistinctMultiMap<TKey, TValue> }

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const AArray: TDynamicArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AArray, AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const AArray: TFixedArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AArray, AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const AArray: array of KVPair<TKey, TValue>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AArray, AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(ACollection, AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: TDynamicArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, AArray, AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: TFixedArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, AArray, AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: array of KVPair<TKey, TValue>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, AArray, AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, AAscendingKeys);
end;

constructor TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscValues := AAscendingValues;
  inherited Create(AKeyType, AValueType, ACollection, AAscendingKeys);
end;

function TDoubleSortedDistinctMultiMap<TKey, TValue>.CreateSet(const AValueType: IType<TValue>): ISet<TValue>;
begin
  { Create a simple list }
  Result := TSortedSet<TValue>.Create(AValueType, FAscValues);
end;

procedure TDoubleSortedDistinctMultiMap<TKey, TValue>.DeserializePair(const AKey: TKey; const AValue: TValue);
begin
  { Write the ascending sign }
  Add(AKey, AValue);
end;

procedure TDoubleSortedDistinctMultiMap<TKey, TValue>.StartDeserializing(const AData: TDeserializationData);
var
  LAscKeys, LAscValues: Boolean;
begin
  { Try to obtain the ascending sign }
  AData.GetValue(SSerAscendingKeys, LAscKeys);
  AData.GetValue(SSerAscendingValues, LAscValues);

  { Call the constructor in this instance to initialize myself first }
  Create(LAscKeys, LAscValues);
end;

procedure TDoubleSortedDistinctMultiMap<TKey, TValue>.StartSerializing(const AData: TSerializationData);
begin
  inherited;

  { Write the ascending sign }
  AData.AddValue(SSerAscendingValues, FAscValues);
end;

{ TObjectDoubleSortedDistinctMultiMap<TKey, TValue> }

procedure TObjectDoubleSortedDistinctMultiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TMaybeObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TMaybeObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectDoubleSortedDistinctMultiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectDoubleSortedDistinctMultiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectDoubleSortedDistinctMultiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectDoubleSortedDistinctMultiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;

end.
