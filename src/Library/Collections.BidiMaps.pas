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
unit Collections.BidiMaps;
interface
uses
  SysUtils,
  DeHL.Base,
  DeHL.Exceptions,
  DeHL.Types,
  DeHL.Arrays,
  DeHL.Serialization,
  DeHL.Collections.Base,
  DeHL.Collections.Abstract,
  DeHL.Collections.DistinctMultiMap;


type
  ///  <summary>The base abstract class for all <c>bidi-maps</c> in DeHL.</summary>
  TAbstractBidiMap<TKey, TValue> = class abstract(TEnexAssociativeCollection<TKey, TValue>, IBidiMap<TKey, TValue>)
  private
    FByKeyMap: IDistinctMultiMap<TKey, TValue>;
    FByValueMap: IDistinctMultiMap<TValue, TKey>;

    { Got from the underlying collections }
    FValueCollection: IEnexCollection<TValue>;
    FKeyCollection: IEnexCollection<TKey>;

  protected
    ///  <summary>Specifies the internal map used as back-end to store key relations.</summary>
    ///  <returns>A map used as back-end.</summary>
    property ByKeyMap: IDistinctMultiMap<TKey, TValue> read FByKeyMap;

    ///  <summary>Specifies the internal map used as back-end to store value relations.</summary>
    ///  <returns>A map used as back-end.</summary>
    property ByValueMap: IDistinctMultiMap<TValue, TKey> read FByValueMap;

    ///  <summary>Called when the map needs to initialize its internal key map.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    function CreateKeyMap(const AKeyType: IType<TKey>;
      const AValueType: IType<TValue>): IDistinctMultiMap<TKey, TValue>; virtual; abstract;

    ///  <summary>Called when the map needs to initialize its internal value map.</summary>
    ///  <param name="AValueType">The type object describing the values.</param>
    function CreateValueMap(const AValueType: IType<TValue>;
      const AKeyType: IType<TKey>): IDistinctMultiMap<TValue, TKey>; virtual; abstract;

    ///  <summary>Returns the number of pairs in the bidi-map.</summary>
    ///  <returns>A positive value specifying the total number of pairs in the bidi-map.</returns>
    function GetCount(): NativeUInt; override;

    ///  <summary>Returns the collection of keys associated with a value.</summary>
    ///  <param name="AValue">The value for which to obtain the associated keys.</param>
    ///  <returns>An Enex collection that contains the values associated with this key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">The value is not found in the bidi-map.</exception>
    function GetKeyList(const AValue: TValue): IEnexCollection<TKey>;

    ///  <summary>Returns the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <returns>An Enex collection that contains the values associated with this key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">The key is not found in the bidi-map.</exception>
    function GetValueList(const AKey: TKey): IEnexCollection<TValue>;
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
    ///  <param name="AKeyType">A type object decribing the keys in the bidi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the bidi-map.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the bidi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the bidi-map.</param>
    ///  <param name="ACollection">A collection to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const ACollection: IEnumerable<KVPair<TKey,TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the bidi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the bidi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: array of KVPair<TKey,TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the bidi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the bidi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: TDynamicArray<KVPair<TKey,TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyType">A type object decribing the keys in the bidi-map.</param>
    ///  <param name="AValueType">A type object decribing the values in the bidi-map.</param>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AKeyType"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AValueType"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
          const AArray: TFixedArray<KVPair<TKey,TValue>>); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead.</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the bidi-map.</summary>
    ///  <remarks>This method clears the bidi-map and invokes type object's cleaning routines for key and value.</remarks>
    procedure Clear();

    ///  <summary>Adds a key-value pair to the bidi-map.</summary>
    ///  <param name="APair">The key-value pair to add.</param>
    ///  <exception cref="DeHL.Exceptions|EDuplicateKeyException">The map already contains a pair with the given key.</exception>
    procedure Add(const APair: KVPair<TKey, TValue>); overload;

    ///  <summary>Adds a key-value pair to the bidi-map.</summary>
    ///  <param name="AKey">The key of pair.</param>
    ///  <param name="AValue">The value associated with the key.</param>
    ///  <exception cref="DeHL.Exceptions|EDuplicateKeyException">The map already contains a pair with the given key.</exception>
    procedure Add(const AKey: TKey; const AValue: TValue); overload;

    ///  <summary>Removes a key-value pair using a given key.</summary>
    ///  <param name="AKey">The key (and its associated values) to remove.</param>
    ///  <remarks>This method removes all the values that are associated with the given key. The type object's cleanup
    ///  routines are used to cleanup the values that are dropped from the bidi-map.</remarks>
    procedure RemoveKey(const AKey: TKey);

    ///  <summary>Removes a key-value pair using a given key.</summary>
    ///  <param name="AKey">The key of pair.</param>
    ///  <remarks>This invokes type object's cleaning routines for value
    ///  associated with the key. If the specified key was not found in the bidi-map, nothing happens.</remarks>
    procedure Remove(const AKey: TKey); overload;

    ///  <summary>Removes a key-value pair using a given value.</summary>
    ///  <param name="AValue">The value (and its associated keys) to remove.</param>
    ///  <remarks>This method removes all the keys that are associated with the given value. The type object's cleanup
    ///  routines are used to cleanup the keys that are dropped from the bidi-map.</remarks>
    procedure RemoveValue(const AValue: TValue);

    ///  <summary>Removes a specific key-value combination.</summary>
    ///  <param name="AKey">The key to remove.</param>
    ///  <param name="AValue">The value to remove.</param>
    ///  <remarks>This method only remove a key-value combination if that combination actually exists in the bidi-map.
    ///  If the key is associated with another value, nothing happens.</remarks>
    procedure Remove(const AKey: TKey; const AValue: TValue); overload;

    ///  <summary>Removes a key-value combination.</summary>
    ///  <param name="APair">The pair to remove.</param>
    ///  <remarks>This method only remove a key-value combination if that combination actually exists in the bidi-map.
    ///  If the key is associated with another value, nothing happens.</remarks>
    procedure Remove(const APair: KVPair<TKey, TValue>); overload;

    ///  <summary>Checks whether the map contains a key-value pair identified by the given key.</summary>
    ///  <param name="AKey">The key to check for.</param>
    ///  <returns><c>True</c> if the map contains a pair identified by the given key; <c>False</c> otherwise.</returns>
    function ContainsKey(const AKey: TKey): Boolean;

    ///  <summary>Checks whether the map contains a key-value pair that contains a given value.</summary>
    ///  <param name="AValue">The value to check for.</param>
    ///  <returns><c>True</c> if the map contains a pair containing the given value; <c>False</c> otherwise.</returns>
    function ContainsValue(const AValue: TValue): Boolean;

    ///  <summary>Checks whether the map contains the given key-value combination.</summary>
    ///  <param name="AKey">The key associated with the value.</param>
    ///  <param name="AValue">The value associated with the key.</param>
    ///  <returns><c>True</c> if the map contains the given association; <c>False</c> otherwise.</returns>
    function ContainsPair(const AKey: TKey; const AValue: TValue): Boolean; overload;

    ///  <summary>Checks whether the map contains a given key-value combination.</summary>
    ///  <param name="APair">The key-value pair combination.</param>
    ///  <returns><c>True</c> if the map contains the given association; <c>False</c> otherwise.</returns>
    function ContainsPair(const APair: KVPair<TKey, TValue>): Boolean; overload;

    ///  <summary>Returns the collection of values associated with a key.</summary>
    ///  <param name="AKey">The key for which to obtain the associated values.</param>
    ///  <returns>An Enex collection that contains the values associated with this key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">The key is not found in the bidi-map.</exception>
    property ByKey[const AKey: TKey]: IEnexCollection<TValue> read GetValueList;

    ///  <summary>Returns the collection of keys associated with a value.</summary>
    ///  <param name="AValue">The value for which to obtain the associated keys.</param>
    ///  <returns>An Enex collection that contains the values associated with this key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">The value is not found in the bidi-map.</exception>
    property ByValue[const AValue: TValue]: IEnexCollection<TKey> read GetKeyList;

    ///  <summary>Specifies the collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the bidi-map.</returns>
    property Keys: IEnexCollection<TKey> read FKeyCollection;

    ///  <summary>Specifies the collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the bidi-map.</returns>
    property Values: IEnexCollection<TValue> read FValueCollection;

    ///  <summary>Returns the number of pairs in the bidi-map.</summary>
    ///  <returns>A positive value specifying the total number of pairs in the bidi-map.</returns>
    property Count: NativeUInt read GetCount;

    ///  <summary>Returns a new enumerator object used to enumerate this bidi-map.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the bidi-map.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<KVPair<TKey, TValue>>; override;

    ///  <summary>Copies the values stored in the bidi-map to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the bidi-map.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the bidi-map.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of KVPair<TKey,TValue>; const AStartIndex: NativeUInt); overload; override;

    ///  <summary>Returns the value associated with the given key.</summary>
    ///  <param name="AKey">The key for which to return the associated value.</param>
    ///  <returns>The value associated with the given key.</returns>
    ///  <exception cref="DeHL.Exceptions|EKeyNotFoundException">No such key in the bidi-map.</exception>
    function ValueForKey(const AKey: TKey): TValue; override;

    ///  <summary>Checks whether the bidi-map contains a given key-value pair.</summary>
    ///  <param name="AKey">The key part of the pair.</param>
    ///  <param name="AValue">The value part of the pair.</param>
    ///  <returns><c>True</c> if the given key-value pair exists; <c>False</c> otherwise.</returns>
    function KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean; override;

    ///  <summary>Returns an Enex collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the bidi-map.</returns>
    function SelectKeys(): IEnexCollection<TKey>; override;

    ///  <summary>Returns a Enex collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the bidi-map.</returns>
    function SelectValues(): IEnexCollection<TValue>; override;
  end;

type
  ///  <summary>The generic <c>bidirectional map</c> collection.</summary>
  ///  <remarks>This type uses <c>distinct multimaps</c> to store its keys and values.</remarks>
  TBidiMap<TKey, TValue> = class(TAbstractBidiMap<TKey, TValue>)
  private
    FInitialCapacity: NativeUInt;

  protected
    ///  <summary>Called when the map needs to initialize the key multimap.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a distinct multimap used as the underlying back-end for the map.</remarks>
    function CreateKeyMap(const AKeyType: IType<TKey>;
      const AValueType: IType<TValue>): IDistinctMultiMap<TKey, TValue>; override;

    ///  <summary>Called when the map needs to initialize the value multimap.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a distinct multimap used as the underlying back-end for the map.</remarks>
    function CreateValueMap(const AValueType: IType<TValue>;
      const AKeyType: IType<TKey>): IDistinctMultiMap<TValue, TKey>; override;

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

  ///  <summary>The generic <c>bidirectional map</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses <c>distinct multimaps</c> to store its keys and values.</remarks>
  TObjectBidiMap<TKey, TValue> = class(TBidiMap<TKey, TValue>)
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
  ///  <summary>The generic <c>bidirectional map</c> collection.</summary>
  ///  <remarks>This type uses <c>sorted distinct multimaps</c> to store its keys and values.</remarks>
  TSortedBidiMap<TKey, TValue> = class(TAbstractBidiMap<TKey, TValue>)
  private
    FAscSort: Boolean;

  protected
    ///  <summary>Called when the map needs to initialize the key multimap.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a sorted distinct multimap used as the underlying back-end for the map.</remarks>
    function CreateKeyMap(const AKeyType: IType<TKey>;
      const AValueType: IType<TValue>): IDistinctMultiMap<TKey, TValue>; override;

    ///  <summary>Called when the map needs to initialize the value multimap.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a sorted distinct multimap used as the underlying back-end for the map.</remarks>
    function CreateValueMap(const AValueType: IType<TValue>;
      const AKeyType: IType<TKey>): IDistinctMultiMap<TValue, TKey>; override;

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

  ///  <summary>The generic <c>bidirectional map</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses <c>sorted distinct multimaps</c> to store its keys and values.</remarks>
  TObjectSortedBidiMap<TKey, TValue> = class(TSortedBidiMap<TKey, TValue>)
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
    ///  <param name="AKeyType">The key's type object to install.</returns>
    ///  <param name="AValueType">The value's type object to install.</returns>
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
  ///  <summary>The generic <c>bidirectional map</c> collection.</summary>
  ///  <remarks>This type uses <c>double sorted distinct multimaps</c> to store its keys and values.</remarks>
  TDoubleSortedBidiMap<TKey, TValue> = class(TAbstractBidiMap<TKey, TValue>)
  private
    FAscKeys, FAscValues: Boolean;

  protected
    ///  <summary>Called when the map needs to initialize the key multimap.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a double sorted distinct multimap used as the underlying back-end for the map.</remarks>
    function CreateKeyMap(const AKeyType: IType<TKey>;
      const AValueType: IType<TValue>): IDistinctMultiMap<TKey, TValue>; override;

    ///  <summary>Called when the map needs to initialize the value multimap.</summary>
    ///  <param name="AKeyType">The type object describing the keys.</param>
    ///  <param name="AValueType">The type object describing the values.</param>
    ///  <remarks>This method creates a double sorted distinct multimap used as the underlying back-end for the map.</remarks>
    function CreateValueMap(const AValueType: IType<TValue>;
      const AKeyType: IType<TKey>): IDistinctMultiMap<TValue, TKey>; override;

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

    ///  <summary>Returns the biggest key.</summary>
    ///  <returns>The biggest key stored in the map.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The map is empty.</exception>
    function MaxKey(): TKey; override;

    ///  <summary>Returns the smallest key.</summary>
    ///  <returns>The smallest key stored in the map.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The map is empty.</exception>
    function MinKey(): TKey; override;
  end;

  ///  <summary>The generic <c>bidirectional map</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses <c>double sorted distinct multimaps</c> to store its keys and values.</remarks>
  TObjectDoubleSortedBidiMap<TKey, TValue> = class(TDoubleSortedBidiMap<TKey, TValue>)
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
    ///  <param name="AKeyType">The key's type object to install.</returns>
    ///  <param name="AValueType">The value's type object to install.</returns>
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


{ TAbstractBidiMap<TKey, TValue> }

constructor TAbstractBidiMap<TKey, TValue>.Create(const AArray: TDynamicArray<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractBidiMap<TKey, TValue>.Create(const AArray: TFixedArray<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractBidiMap<TKey, TValue>.Create(const AArray: array of KVPair<TKey, TValue>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, AArray);
end;

constructor TAbstractBidiMap<TKey, TValue>.Create;
begin
  Create(TType<TKey>.Default, TType<TValue>.Default);
end;

constructor TAbstractBidiMap<TKey, TValue>.Create(const ACollection: IEnumerable<KVPair<TKey, TValue>>);
begin
  Create(TType<TKey>.Default, TType<TValue>.Default, ACollection);
end;

constructor TAbstractBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
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

procedure TAbstractBidiMap<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue);
begin
  { Add the K/V pair to the maps }
  FByKeyMap.Add(AKey, AValue);
  FByValueMap.Add(AValue, AKey);
end;

procedure TAbstractBidiMap<TKey, TValue>.Add(const APair: KVPair<TKey, TValue>);
begin
  Add(APair.Key, APair.Value);
end;

procedure TAbstractBidiMap<TKey, TValue>.Clear;
begin
  if FByKeyMap <> nil then
    FByKeyMap.Clear;

  if FByValueMap <> nil then
    FByValueMap.Clear;
end;

function TAbstractBidiMap<TKey, TValue>.ContainsKey(const AKey: TKey): Boolean;
begin
  Result := FByKeyMap.ContainsKey(AKey);
end;

function TAbstractBidiMap<TKey, TValue>.ContainsPair(const APair: KVPair<TKey, TValue>): Boolean;
begin
  { The the by-key relation since it is correct always }
  Result := FByKeyMap.ContainsValue(APair.Key, APair.Value);
end;

function TAbstractBidiMap<TKey, TValue>.ContainsPair(const AKey: TKey; const AValue: TValue): Boolean;
begin
  { The the by-key relation since it is correct always }
  Result := FByKeyMap.ContainsValue(AKey, AValue);
end;

function TAbstractBidiMap<TKey, TValue>.ContainsValue(const AValue: TValue): Boolean;
begin
  Result := FByValueMap.ContainsKey(AValue);
end;

procedure TAbstractBidiMap<TKey, TValue>.CopyTo(var AArray: array of KVPair<TKey, TValue>; const AStartIndex: NativeUInt);
begin
  { Check for indexes }
  if AStartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (NativeUInt(Length(AArray)) - AStartIndex) < Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  { Call the underlying collection }
  FByKeyMap.CopyTo(AArray, AStartIndex);
end;

constructor TAbstractBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
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

destructor TAbstractBidiMap<TKey, TValue>.Destroy;
begin
  { Clear out the instance }
  Clear();

  inherited;
end;

function TAbstractBidiMap<TKey, TValue>.GetCount: NativeUInt;
begin
  { The cound follows the map properties }
  Result := FByKeyMap.Count;
end;

function TAbstractBidiMap<TKey, TValue>.GetEnumerator: IEnumerator<KVPair<TKey, TValue>>;
begin
  { Pass the enumerator from the key map }
  Result := FByKeyMap.GetEnumerator();
end;

function TAbstractBidiMap<TKey, TValue>.GetKeyList(const AValue: TValue): IEnexCollection<TKey>;
begin
  Result := FByValueMap[AValue];
end;

function TAbstractBidiMap<TKey, TValue>.GetValueList(const AKey: TKey): IEnexCollection<TValue>;
begin
  Result := FByKeyMap[AKey];
end;

function TAbstractBidiMap<TKey, TValue>.KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean;
begin
  Result := ContainsPair(AKey, AValue);
end;

procedure TAbstractBidiMap<TKey, TValue>.Remove(const AKey: TKey; const AValue: TValue);
var
  LValues: IEnexCollection<TValue>;
  LValue: TValue;
begin
  { Check whether there is such a key }
  if not FByKeyMap.ContainsValue(AKey, AValue) then
    Exit;

  { Remove the stuff }
  FByKeyMap.Remove(AKey, AValue);
  FByValueMap.Remove(AValue, AKey);
end;

procedure TAbstractBidiMap<TKey, TValue>.Remove(const APair: KVPair<TKey, TValue>);
begin
  Remove(APair.Key, APair.Value);
end;

procedure TAbstractBidiMap<TKey, TValue>.Remove(const AKey: TKey);
begin
  RemoveKey(AKey);
end;

procedure TAbstractBidiMap<TKey, TValue>.RemoveKey(const AKey: TKey);
var
  LValues: IEnexCollection<TValue>;
  LValue: TValue;
begin
  { Check whether there is such a key }
  if not FByKeyMap.TryGetValues(AKey, LValues) then
    Exit;

  { Exclude the key for all values too }
  for LValue in LValues do
    FByValueMap.Remove(LValue, AKey);

  { And finally remove the key }
  FByKeyMap.Remove(AKey);
end;

procedure TAbstractBidiMap<TKey, TValue>.RemoveValue(const AValue: TValue);
var
  LKeys: IEnexCollection<TKey>;
  LValue: TKey;
begin
  { Check whether there is such a key }
  if not FByValueMap.TryGetValues(AValue, LKeys) then
    Exit;

  { Exclude the key for all values too}
  for LValue in LKeys do
    FByKeyMap.Remove(LValue, AValue);

  { And finally remove the key }
  FByValueMap.Remove(AValue);

//  { Cleanup the value if necessary }
//  if ValueType.Management = tmManual then
//    ValueType.Cleanup(LValue);
end;

function TAbstractBidiMap<TKey, TValue>.SelectKeys: IEnexCollection<TKey>;
begin
  { Pass the values on }
  Result := Keys;
end;

function TAbstractBidiMap<TKey, TValue>.SelectValues: IEnexCollection<TValue>;
begin
  { Pass the value on }
  Result := Values;
end;

function TAbstractBidiMap<TKey, TValue>.ValueForKey(const AKey: TKey): TValue;
begin
  Result := FByKeyMap[AKey].First;
end;

constructor TAbstractBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
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

constructor TAbstractBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
var
  LKeyWrap: IType<TKey>;
  LValueWrap: IType<TValue>;
begin
  { Initialize instance }
  if (AKeyType = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AKeyType');

  if (AValueType = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AValueType');

  { Install the types }
  InstallTypes(AKeyType, AValueType);

  { Create type wrappers - basically disabling the cleanup for pne of the maps }
  LKeyWrap := TSuppressedWrapperType<TKey>.Create(KeyType);
  LValueWrap := TSuppressedWrapperType<TValue>.Create(ValueType);

  { Create the maps }
  FByKeyMap := CreateKeyMap(LKeyWrap, ValueType);
  FByValueMap := CreateValueMap(LValueWrap, KeyType);

  { The collections }
  FValueCollection := FByValueMap.Keys;
  FKeyCollection := FByKeyMap.Keys;
end;

constructor TAbstractBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
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


const
  DefaultArrayLength = 32;

{ TBidiMap<TKey, TValue> }

constructor TBidiMap<TKey, TValue>.Create(const AInitialCapacity: NativeUInt);
begin
  FInitialCapacity := AInitialCapacity;

  inherited Create();
end;

constructor TBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>; const AValueType: IType<TValue>; const AInitialCapacity: NativeUInt);
begin
  FInitialCapacity := AInitialCapacity;

  inherited Create(AKeyType, AValueType);
end;

function TBidiMap<TKey, TValue>.CreateKeyMap(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>): IDistinctMultiMap<TKey, TValue>;
var
  Cap: NativeUInt;
begin
  { Create a simple dictionary }
  if FInitialCapacity = 0 then
    Cap := DefaultArrayLength
  else
    Cap := FInitialCapacity;

  { Use a simple non-sorted map }
  Result := TDistinctMultiMap<TKey, TValue>.Create(AKeyType, AValueType, Cap);
end;

function TBidiMap<TKey, TValue>.CreateValueMap(const AValueType: IType<TValue>;
  const AKeyType: IType<TKey>): IDistinctMultiMap<TValue, TKey>;
var
  Cap: NativeUInt;
begin
  { Create a simple dictionary }
  if FInitialCapacity = 0 then
    Cap := DefaultArrayLength
  else
    Cap := FInitialCapacity;

  { Use a simple non-sorted map }
  Result := TDistinctMultiMap<TValue, TKey>.Create(AValueType, AKeyType, Cap);
end;

procedure TBidiMap<TKey, TValue>.DeserializePair(const AKey: TKey; const AValue: TValue);
begin
  { Very simple }
  Add(AKey, AValue);
end;

procedure TBidiMap<TKey, TValue>.StartDeserializing(const AData: TDeserializationData);
begin
  { Call the constructor in this instance to initialize myself first }
  Create();
end;

procedure TBidiMap<TKey, TValue>.StartSerializing(const AData: TSerializationData);
begin
  // Do nothing, just say that I am here and I can be serialized
end;

{ TObjectBidiMap<TKey, TValue> }

procedure TObjectBidiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TMaybeObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TMaybeObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectBidiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectBidiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectBidiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectBidiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;

{ TSortedBidiMap<TKey, TValue> }


constructor TSortedBidiMap<TKey, TValue>.Create(
  const AArray: TDynamicArray<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AArray);
end;

constructor TSortedBidiMap<TKey, TValue>.Create(
  const AArray: TFixedArray<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AArray);
end;

constructor TSortedBidiMap<TKey, TValue>.Create(
  const AArray: array of KVPair<TKey, TValue>; const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AArray);
end;

constructor TSortedBidiMap<TKey, TValue>.Create(const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create();
end;

constructor TSortedBidiMap<TKey, TValue>.Create(
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(ACollection);
end;

constructor TSortedBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TDynamicArray<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: TFixedArray<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const AArray: array of KVPair<TKey, TValue>; const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TSortedBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>; const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType);
end;

constructor TSortedBidiMap<TKey, TValue>.Create(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>;
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  { Do the dew and continue }
  FAscSort := AAscending;
  inherited Create(AKeyType, AValueType, ACollection);
end;

function TSortedBidiMap<TKey, TValue>.CreateKeyMap(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>): IDistinctMultiMap<TKey, TValue>;
begin
  { Use a simple sorted map }
  Result := TSortedDistinctMultiMap<TKey, TValue>.Create(AKeyType, AValueType, FAscSort);
end;

function TSortedBidiMap<TKey, TValue>.CreateValueMap(const AValueType: IType<TValue>;
  const AKeyType: IType<TKey>): IDistinctMultiMap<TValue, TKey>;
begin
  { Use a simple sorted map }
  Result := TSortedDistinctMultiMap<TValue, TKey>.Create(AValueType, AKeyType, FAscSort);
end;

procedure TSortedBidiMap<TKey, TValue>.DeserializePair(const AKey: TKey; const AValue: TValue);
begin
  { Very simple }
  Add(AKey, AValue);
end;

function TSortedBidiMap<TKey, TValue>.MaxKey: TKey;
begin
  Result := ByKeyMap.MaxKey;
end;

function TSortedBidiMap<TKey, TValue>.MinKey: TKey;
begin
  Result := ByKeyMap.MinKey;
end;

procedure TSortedBidiMap<TKey, TValue>.StartDeserializing(const AData: TDeserializationData);
var
  LAsc: Boolean;
begin
  { Try to obtain the ascending sign }
  AData.GetValue(SSerAscendingKeys, LAsc);

  { Call the constructor in this instance to initialize myself first }
  Create(LAsc);
end;

procedure TSortedBidiMap<TKey, TValue>.StartSerializing(const AData: TSerializationData);
begin
  { Write the ascending sign }
  AData.AddValue(SSerAscendingKeys, FAscSort);
end;

{ TObjectSortedBidiMap<TKey, TValue> }

procedure TObjectSortedBidiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TMaybeObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TMaybeObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectSortedBidiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectSortedBidiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectSortedBidiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectSortedBidiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;


{ TDoubleSortedBidiMap<TKey, TValue> }

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const AArray: TDynamicArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(AArray);
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const AArray: TFixedArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(AArray);
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const AArray: array of KVPair<TKey, TValue>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(AArray);
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create();
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(ACollection);
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: TDynamicArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: TFixedArray<KVPair<TKey, TValue>>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AArray: array of KVPair<TKey, TValue>; const AAscendingKeys,
  AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(AKeyType, AValueType, AArray);
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(AKeyType, AValueType);
end;

constructor TDoubleSortedBidiMap<TKey, TValue>.Create(
  const AKeyType: IType<TKey>; const AValueType: IType<TValue>;
  const ACollection: IEnumerable<KVPair<TKey, TValue>>;
  const AAscendingKeys, AAscendingValues: Boolean);
begin
  { Do da dew and continue! }
  FAscKeys := AAscendingKeys;
  FAscValues := AAscendingValues;

  inherited Create(AKeyType, AValueType, ACollection);
end;

function TDoubleSortedBidiMap<TKey, TValue>.CreateKeyMap(const AKeyType: IType<TKey>;
  const AValueType: IType<TValue>): IDistinctMultiMap<TKey, TValue>;
begin
  { Use a double sorted map }
  Result := TDoubleSortedDistinctMultiMap<TKey, TValue>.Create(AKeyType, AValueType, FAscKeys, FAscValues);
end;

function TDoubleSortedBidiMap<TKey, TValue>.CreateValueMap(const AValueType: IType<TValue>;
  const AKeyType: IType<TKey>): IDistinctMultiMap<TValue, TKey>;
begin
  { Use a double sorted map }
  Result := TDoubleSortedDistinctMultiMap<TValue, TKey>.Create(AValueType, AKeyType, FAscKeys, FAscValues);
end;

procedure TDoubleSortedBidiMap<TKey, TValue>.DeserializePair(const AKey: TKey; const AValue: TValue);
begin
  { Simple as that }
  Add(AKey, AValue);
end;

function TDoubleSortedBidiMap<TKey, TValue>.MaxKey: TKey;
begin
  Result := ByKeyMap.MaxKey;
end;

function TDoubleSortedBidiMap<TKey, TValue>.MinKey: TKey;
begin
  Result := ByKeyMap.MinKey;
end;

procedure TDoubleSortedBidiMap<TKey, TValue>.StartDeserializing(const AData: TDeserializationData);
var
  LAscKeys, LAscValues: Boolean;
begin
  { Try to obtain the ascending sign }
  AData.GetValue(SSerAscendingKeys, LAscKeys);
  AData.GetValue(SSerAscendingValues, LAscValues);

  { Call the constructor in this instance to initialize myself first }
  Create(LAscKeys, LAscValues);
end;

procedure TDoubleSortedBidiMap<TKey, TValue>.StartSerializing(const AData: TSerializationData);
begin
  { Write the ascending sign }
  AData.AddValue(SSerAscendingKeys, FAscKeys);
  AData.AddValue(SSerAscendingValues, FAscValues);
end;

{ TObjectDoubleSortedBidiMap<TKey, TValue> }

procedure TObjectDoubleSortedBidiMap<TKey, TValue>.InstallTypes(const AKeyType: IType<TKey>; const AValueType: IType<TValue>);
begin
  { Create a wrapper over the real type class and switch it }
  FKeyWrapperType := TMaybeObjectWrapperType<TKey>.Create(AKeyType);
  FValueWrapperType := TMaybeObjectWrapperType<TValue>.Create(AValueType);

  { Install overridden type }
  inherited InstallTypes(FKeyWrapperType, FValueWrapperType);
end;

function TObjectDoubleSortedBidiMap<TKey, TValue>.GetOwnsKeys: Boolean;
begin
  Result := FKeyWrapperType.AllowCleanup;
end;

function TObjectDoubleSortedBidiMap<TKey, TValue>.GetOwnsValues: Boolean;
begin
  Result := FValueWrapperType.AllowCleanup;
end;

procedure TObjectDoubleSortedBidiMap<TKey, TValue>.SetOwnsKeys(const Value: Boolean);
begin
  FKeyWrapperType.AllowCleanup := Value;
end;

procedure TObjectDoubleSortedBidiMap<TKey, TValue>.SetOwnsValues(const Value: Boolean);
begin
  FValueWrapperType.AllowCleanup := Value;
end;

end.
