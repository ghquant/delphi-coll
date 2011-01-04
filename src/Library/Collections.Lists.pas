(*
* Copyright (c) 2008-2010, Ciobanu Alexandru
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

{$I Collections.inc}
unit Collections.Lists;
interface
uses SysUtils,
     Generics.Defaults,
     Collections.Base;

type

  ///  <summary>The generic <c>list</c> collection.</summary>
  ///  <remarks>This type uses an internal array to store its values.</remarks>
  TList<T> = class(TEnexCollection<T>, IEnexIndexedCollection<T>, IList<T>, IUnorderedList<T>, IDynamic)
  private type
    {$REGION 'Internal Types'}
{$IFDEF OPTIMIZED_SORT}
    { Stack entry }
    TStackEntry = record
      First, Last: NativeInt;
    end;

    { Required for the non-recursive QSort }
    TQuickSortStack = array[0..63] of TStackEntry;
{$ENDIF}

    TEnumerator = class(TEnumerator<T>)
    private
      FVer: NativeUInt;
      FList: TList<T>;
      FCurrentIndex: NativeUInt;

    public
      { Constructor }
      constructor Create(const AList: TList<T>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): T; override;
      function MoveNext(): Boolean; override;
    end;
    {$ENDREGION}

  private var
    FArray: TArray<T>;
    FLength: NativeUInt;
    FVer: NativeUInt;

    procedure QuickSort(ALeft, ARight: NativeInt; const ASortProc: TComparison<T>); overload;
    procedure QuickSort(ALeft, ARight: NativeInt; const AAscending: Boolean); overload;
  protected
    ///  <summary>Returns the item from a given index.</summary>
    ///  <param name="AIndex">The index in the list.</param>
    ///  <returns>The element at the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    function GetItem(const AIndex: NativeUInt): T;

    ///  <summary>Sets the item at a given index.</summary>
    ///  <param name="AIndex">The index in the list.</param>
    ///  <param name="AValue">The new value.</param>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    procedure SetItem(const AIndex: NativeUInt; const AValue: T);

    ///  <summary>Returns the number of elements in the list.</summary>
    ///  <returns>A positive value specifying the number of elements in the list.</returns>
    function GetCount(): NativeUInt; override;

    ///  <summary>Returns the current capacity.</summary>
    ///  <returns>A positive number that specifies the number of elements that the list can hold before it
    ///  needs to grow again.</returns>
    ///  <remarks>The value of this method is greater or equal to the amount of elements in the list. If this value
    ///  is greater then the number of elements, it means that the list has some extra capacity to operate upon.</remarks>
    function GetCapacity(): NativeUInt;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The list's initial capacity.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AInitialCapacity: NativeUInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const ACollection: IEnumerable<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of T); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The list's initial capacity.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AInitialCapacity: NativeUInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AArray: array of T); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead.</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the list.</summary>
    ///  <remarks>This method clears the list and invokes type object's cleaning routines for each element.</remarks>
    procedure Clear();

    ///  <summary>Appends an element to the list.</summary>
    ///  <param name="AValue">The value to append.</param>
    procedure Add(const AValue: T); overload;

    ///  <summary>Appends the elements from a collection to the list.</summary>
    ///  <param name="ACollection">The values to append.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    procedure Add(const ACollection: IEnumerable<T>); overload;

    ///  <summary>Inserts an element into the list.</summary>
    ///  <param name="AIndex">The index to insert to.</param>
    ///  <param name="AValue">The value to insert.</param>
    ///  <remarks>All elements starting with <paramref name="AIndex"/> are moved to the right by one and then
    ///  <paramref name="AValue"/> is placed at position <paramref name="AIndex"/>.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    procedure Insert(const AIndex: NativeUInt; const AValue: T); overload;

    ///  <summary>Inserts the elements of a collection into the list.</summary>
    ///  <param name="AIndex">The index to insert to.</param>
    ///  <param name="ACollection">The values to insert.</param>
    ///  <remarks>All elements starting with <paramref name="AIndex"/> are moved to the right by the length of
    ///  <paramref name="ACollection"/> and then <paramref name="AValue"/> is placed at position <paramref name="AIndex"/>.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    procedure Insert(const AIndex: NativeUInt; const ACollection: IEnumerable<T>); overload;

    ///  <summary>Removes a given value from the list.</summary>
    ///  <param name="AValue">The value to remove.</param>
    ///  <remarks>If the list does not contain the given value, nothing happens.</remarks>
    procedure Remove(const AValue: T);

    ///  <summary>Removes an element from the list at a given index.</summary>
    ///  <param name="AIndex">The index from which to remove the element.</param>
    ///  <remarks>This method removes the specified element and moves all following elements to the left by one.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    procedure RemoveAt(const AIndex: NativeUInt);

    ///  <summary>Reverses the elements in this list.</summary>
    ///  <param name="AStartIndex">The start index.</param>
    ///  <param name="ACount">The count of elements.</param>
    ///  <remarks>This method reverses <paramref name="ACount"/> number of elements in
    ///  the the list, starting with <paramref name="AStartIndex"/> element.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    procedure Reverse(const AStartIndex, ACount: NativeUInt); overload;

    ///  <summary>Reverses the elements in this list.</summary>
    ///  <param name="AStartIndex">The start index.</param>
    ///  <remarks>This method reverses all elements in the list, starting with <paramref name="AStartIndex"/> element.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    procedure Reverse(const AStartIndex: NativeUInt); overload;

    ///  <summary>Reverses the elements in this list.</summary>
    procedure Reverse(); overload;

    ///  <summary>Sorts the contents of this list.</summary>
    ///  <param name="AStartIndex">The start index.</param>
    ///  <param name="ACount">The count of elements.</param>
    ///  <param name="AAscending">Specifies whether ascending or descending sorting is performed. Default is <c>True</c>.</param>
    ///  <remarks>This method sorts <paramref name="ACount"/> number of elements in
    ///  the list, starting with <paramref name="AStartIndex"/> element.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    procedure Sort(const AStartIndex, ACount: NativeUInt; const AAscending: Boolean = true); overload;

    ///  <summary>Sorts the contents of this list.</summary>
    ///  <param name="AStartIndex">The start index.</param>
    ///  <param name="AAscending">Specifies whether ascending or descending sorting is performed. Default is <c>True</c>.</param>
    ///  <remarks>This method sorts all elements in the list, starting with <paramref name="AStartIndex"/> element.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    procedure Sort(const AStartIndex: NativeUInt; const AAscending: Boolean = true); overload;

    ///  <summary>Sorts the contents of this list.</summary>
    ///  <param name="AAscending">Specifies whether ascending or descending sorting is performed. Default is <c>True</c>.</param>
    procedure Sort(const AAscending: Boolean = true); overload;

    ///  <summary>Sorts the contents of this list using a given comparison method.</summary>
    ///  <param name="AStartIndex">The start index.</param>
    ///  <param name="ACount">The count of elements.</param>
    ///  <param name="ASortProc">The method used to compare elements.</param>
    ///  <remarks>This method sorts <paramref name="ACount"/> number of elements in
    ///  the list, starting with <paramref name="AStartIndex"/> element.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ASortProc"/> is <c>nil</c>.</exception>
    procedure Sort(const AStartIndex, ACount: NativeUInt; const ASortProc: TComparison<T>); overload;

    ///  <summary>Sorts the contents of this list using a given comparison method.</summary>
    ///  <param name="AStartIndex">The start index.</param>
    ///  <param name="ASortProc">The method used to compare elements.</param>
    ///  <remarks>This method sorts all elements in the list, starting with <paramref name="AStartIndex"/> element.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ASortProc"/> is <c>nil</c>.</exception>
    procedure Sort(const AStartIndex: NativeUInt; const ASortProc: TComparison<T>); overload;

    ///  <summary>Sorts the contents of this list using a given comparison method.</summary>
    ///  <param name="ASortProc">The method used to compare elements.</param>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ASortProc"/> is <c>nil</c>.</exception>
    procedure Sort(const ASortProc: TComparison<T>); overload;

    ///  <summary>Checks whether the list contains a given value.</summary>
    ///  <param name="AValue">The value to check.</param>
    ///  <returns><c>True</c> if the value was found in the list; <c>False</c> otherwise.</returns>
    function Contains(const AValue: T): Boolean;

    ///  <summary>Searches for the first appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <param name="AStartIndex">The index to from which the search starts.</param>
    ///  <param name="ACount">The number of elements after the starting one to check against.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    function IndexOf(const AValue: T; const AStartIndex, ACount: NativeUInt): NativeInt; overload;

    ///  <summary>Searches for the first appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <param name="AStartIndex">The index to from which the search starts.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    function IndexOf(const AValue: T; const AStartIndex: NativeUInt): NativeInt; overload;

    ///  <summary>Searches for the first appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    function IndexOf(const AValue: T): NativeInt; overload;

    ///  <summary>Searches for the last appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <param name="AStartIndex">The index to from which the search starts.</param>
    ///  <param name="ACount">The number of elements after the starting one to check against.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    function LastIndexOf(const AValue: T; const AStartIndex, ACount: NativeUInt): NativeInt; overload;

    ///  <summary>Searches for the last appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <param name="AStartIndex">The index to from which the search starts.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    function LastIndexOf(const AValue: T; const AStartIndex: NativeUInt): NativeInt; overload;

    ///  <summary>Searches for the last appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    function LastIndexOf(const AValue: T): NativeInt; overload;

    ///  <summary>Specifies the number of elements in the list.</summary>
    ///  <returns>A positive value specifying the number of elements in the list.</returns>
    property Count: NativeUInt read FLength;

    ///  <summary>Specifies the current capacity.</summary>
    ///  <returns>A positive number that specifies the number of elements that the list can hold before it
    ///  needs to grow again.</returns>
    ///  <remarks>The value of this property is greater or equal to the amount of elements in the list. If this value
    ///  if greater then the number of elements, it means that the list has some extra capacity to operate upon.</remarks>
    property Capacity: NativeUInt read GetCapacity;

    ///  <summary>Returns the item from a given index.</summary>
    ///  <param name="AIndex">The index in the collection.</param>
    ///  <returns>The element at the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    property Items[const AIndex: NativeUInt]: T read GetItem; default;

    ///  <summary>Returns a new enumerator object used to enumerate this list.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the list.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<T>; override;

    ///  <summary>Removes the excess capacity from the list.</summary>
    ///  <remarks>This method can be called manually to force the list to drop the extra capacity it might hold. For example,
    ///  after performing some massive operations of a big list, call this method to ensure that all extra memory held by the
    ///  list is released.</remarks>
    procedure Shrink();

    ///  <summary>Forces the list to increase its capacity.</summary>
    ///  <remarks>Call this method to force the list to increase its capacity ahead of time. Manually adjusting the capacity
    ///  can be useful in certain situations.</remarks>
    procedure Grow();

    ///  <summary>Copies the specified elements into a new list.</summary>
    ///  <param name="AStartIndex">The index to from which the copy starts.</param>
    ///  <param name="ACount">The number of elements to copy.</param>
    ///  <returns>A new list containing the copied elements.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is invalid.</exception>
    function Copy(const AStartIndex: NativeUInt; const ACount: NativeUInt): TList<T>; overload;

    ///  <summary>Copies the specified elements into a new list.</summary>
    ///  <param name="AStartIndex">The index to from which the copy starts.</param>
    ///  <returns>A new list containing the copied elements.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    function Copy(const AStartIndex: NativeUInt): TList<T>; overload;

    ///  <summary>Creates a copy of this list.</summary>
    ///  <returns>A new list containing the copied elements.</returns>
    function Copy(): TList<T>; overload;

    ///  <summary>Copies the values stored in the list to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the list.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the list.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of T; const AStartIndex: NativeUInt); overload; override;

    ///  <summary>Checks whether the list is empty.</summary>
    ///  <returns><c>True</c> if the list is empty; <c>False</c> otherwise.</returns>
    ///  <remarks>This method is the recommended way of detecting if the list is empty.</remarks>
    function Empty(): Boolean; override;

    ///  <summary>Returns the biggest element.</summary>
    ///  <returns>An element from the list considered to have the biggest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function Max(): T; override;

    ///  <summary>Returns the smallest element.</summary>
    ///  <returns>An element from the list considered to have the smallest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function Min(): T; override;

    ///  <summary>Returns the first element.</summary>
    ///  <returns>The first element in the list.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function First(): T; override;

    ///  <summary>Returns the first element or a default if the list is empty.</summary>
    ///  <param name="ADefault">The default value returned if the list is empty.</param>
    ///  <returns>The first element in list if the list is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function FirstOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the last element.</summary>
    ///  <returns>The last element in the list.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function Last(): T; override;

    ///  <summary>Returns the last element or a default if the list is empty.</summary>
    ///  <param name="ADefault">The default value returned if the list is empty.</param>
    ///  <returns>The last element in list if the list is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function LastOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the single element stored in the list.</summary>
    ///  <returns>The element in list.</returns>
    ///  <remarks>This method checks if the list contains just one element, in which case it is returned.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionNotOneException">There is more than one element in the list.</exception>
    function Single(): T; override;

    ///  <summary>Returns the single element stored in the list, or a default value.</summary>
    ///  <param name="ADefault">The default value returned if there is less or more elements in the list.</param>
    ///  <returns>The element in the list if the condition is satisfied; <paramref name="ADefault"/> is returned otherwise.</returns>
    ///  <remarks>This method checks if the list contains just one element, in which case it is returned. Otherwise
    ///  the value in <paramref name="ADefault"/> is returned.</remarks>
    function SingleOrDefault(const ADefault: T): T; override;

    ///  <summary>Aggregates a value based on the list's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <returns>A value that contains the list's aggregated value.</returns>
    ///  <remarks>This method returns the first element if the list only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function Aggregate(const AAggregator: TFunc<T, T, T>): T; override;

    ///  <summary>Aggregates a value based on the list's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <param name="ADefault">The default value returned if the list is empty.</param>
    ///  <returns>A value that contains the list's aggregated value. If the list is empty, <paramref name="ADefault"/> is returned.</returns>
    ///  <remarks>This method returns the first element if the list only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    function AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <returns>The element from the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    function ElementAt(const AIndex: NativeUInt): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <param name="ADefault">The default value returned if the list is empty.</param>
    ///  <returns>The element from the specified position if the list is not empty and the position is not out of bounds; otherwise
    ///  the value of <paramref name="ADefault"/> is returned.</returns>
    function ElementAtOrDefault(const AIndex: NativeUInt; const ADefault: T): T; override;

    ///  <summary>Check whether at least one element in the list satisfies a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if the at least one element satisfies a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole list and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>True</c>. The logical equivalent of this operation is "OR".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function Any(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks that all elements in the list satisfy a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if all elements satisfy a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole list and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>False</c>. The logical equivalent of this operation is "AND".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function All(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks whether the elements in this list are equal to the elements in another collection.</summary>
    ///  <param name="ACollection">The collection to compare to.</param>
    ///  <returns><c>True</c> if the collections are equal; <c>False</c> if the collections are different.</returns>
    ///  <remarks>This methods checks that each element at position X in this list is equal to an element at position X in
    ///  the provided collection. If the number of elements in both collections are different, then the collections are considered different.
    ///  Note that comparison of element is done using the type object used by this list. This means that comparing this collection
    ///  to another one might yeild a different result than comparing the other collection to this one.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    function EqualsTo(const ACollection: IEnumerable<T>): Boolean; override;
  end;

  ///  <summary>The generic <c>list</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses an internal array to store its objects.</remarks>
  TObjectList<T: class> = class(TList<T>)
  private
    FOwnsObjects: Boolean;
  protected
    //TODO: doc me.
    procedure HandleElementRemoved(const AElement: T); override;

  public
    ///  <summary>Specifies whether this list owns the objects stored in it.</summary>
    ///  <returns><c>True</c> if the list owns its objects; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the list controls the life-time of the stored objects.</remarks>
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

type
  ///  <summary>The generic <c>sorted list</c> collection.</summary>
  ///  <remarks>This type uses an internal array to store its values.</remarks>
  TSortedList<T> = class(TEnexCollection<T>, IEnexIndexedCollection<T>,
    IList<T>, IOrderedList<T>, IDynamic)
  private type
    {$REGION 'Internal Types'}
    TEnumerator = class(TEnumerator<T>)
    private
      FVer: NativeUInt;
      FList: TSortedList<T>;
      FCurrentIndex: NativeUInt;

    public
      { Constructor }
      constructor Create(const AList: TSortedList<T>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): T; override;
      function MoveNext(): Boolean; override;
    end;
    {$ENDREGION}

  private var
    FArray: TArray<T>;
    FLength: NativeUInt;
    FVer: NativeUInt;
    FAscending: Boolean;

     { Internal insertion }
     procedure Insert(const AIndex: NativeUInt; const AValue: T);

     function BinarySearch(const AElement: T; const AStartIndex, ACount: NativeUInt; AAscending: Boolean): NativeInt;
  protected
    ///  <summary>Returns the item from a given index.</summary>
    ///  <param name="AIndex">The index in the list.</param>
    ///  <returns>The element at the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    function GetItem(const AIndex: NativeUInt): T;

    ///  <summary>Returns the number of elements in the list.</summary>
    ///  <returns>A positive value specifying the number of elements in the list.</returns>
    function GetCount(): NativeUInt; override;

    ///  <summary>Returns the current capacity.</summary>
    ///  <returns>A positive number that specifies the number of elements that the list can hold before it
    ///  needs to grow again.</returns>
    ///  <remarks>The value of this method is greater or equal to the amount of elements in the list. If this value
    ///  is greater then the number of elements, it means that the list has some extra capacity to operate upon.</remarks>
    function GetCapacity(): NativeUInt;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <param name="AInitialiCapacity">Specifies the initial capacity of the list.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AInitialCapacity: NativeUInt; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const ACollection: IEnumerable<T>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of T; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ARules">A type object decribing the elements in the list.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ARules">A type object decribing the elements in the list.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <param name="AInitialiCapacity">Specifies the initial capacity of the list.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AInitialCapacity: NativeUInt; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ARules">A type object decribing the elements in the list.</param>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ARules">A type object decribing the elements in the list.</param>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AArray: array of T; const AAscending: Boolean = true); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead.</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the list.</summary>
    ///  <remarks>This method clears the list and invokes type object's cleaning routines for each element.</remarks>
    procedure Clear();

    ///  <summary>Adds an element to the list.</summary>
    ///  <param name="AValue">The value to add.</param>
    ///  <remarks>The added value is not appended. The list tries to figure out whre to insert it to keep its elements
    ///  ordered at all times.</remarks>
    procedure Add(const AValue: T); overload;

    ///  <summary>Add the elements from a collection to the list.</summary>
    ///  <param name="ACollection">The values to add.</param>
    ///  <remarks>The added values are not appended. The list tries to figure out where to insert the new values
    ///  to keep its elements ordered at all times.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    procedure Add(const ACollection: IEnumerable<T>); overload;

    ///  <summary>Removes a given value from the list.</summary>
    ///  <param name="AValue">The value to remove.</param>
    ///  <remarks>If the list does not contain the given value, nothing happens.</remarks>
    procedure Remove(const AValue: T);

    ///  <summary>Removes an element from the list at a given index.</summary>
    ///  <param name="AIndex">The index from which to remove the element.</param>
    ///  <remarks>This method removes the specified element and moves all following elements to the left by one.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    procedure RemoveAt(const AIndex: NativeUInt);

    ///  <summary>Checks whether the list contains a given value.</summary>
    ///  <param name="AValue">The value to check.</param>
    ///  <returns><c>True</c> if the value was found in the list; <c>False</c> otherwise.</returns>
    ///  <remarks>This method uses binary search beacause the list is always sorted.</remarks>
    function Contains(const AValue: T): Boolean;

    ///  <summary>Searches for the first appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <param name="AStartIndex">The index to from which the search starts.</param>
    ///  <param name="ACount">The number of elements after the starting one to check against.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <remarks>This method uses binary search beacause the list is always sorted.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    function IndexOf(const AValue: T; const AStartIndex, ACount: NativeUInt): NativeInt; overload;

    ///  <summary>Searches for the first appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <param name="AStartIndex">The index to from which the search starts.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <remarks>This method uses binary search beacause the list is always sorted.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    function IndexOf(const AValue: T; const AStartIndex: NativeUInt): NativeInt; overload;

    ///  <summary>Searches for the first appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <remarks>This method uses binary search beacause the list is always sorted.</remarks>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    function IndexOf(const AValue: T): NativeInt; overload;

    ///  <summary>Searches for the last appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <param name="AStartIndex">The index to from which the search starts.</param>
    ///  <param name="ACount">The number of elements after the starting one to check against.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <remarks>This method uses binary search beacause the list is always sorted.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is incorrect.</exception>
    function LastIndexOf(const AValue: T; const AStartIndex, ACount: NativeUInt): NativeInt; overload;

    ///  <summary>Searches for the last appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <param name="AStartIndex">The index to from which the search starts.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <remarks>This method uses binary search beacause the list is always sorted.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    function LastIndexOf(const AValue: T; const AStartIndex: NativeUInt): NativeInt; overload;

    ///  <summary>Searches for the last appearance of a given element in this list.</summary>
    ///  <param name="AValue">The value to search for.</param>
    ///  <returns><c>-1</c> if the value was not found; otherwise a positive value indicating the index of the value.</returns>
    ///  <remarks>This method uses binary search beacause the list is always sorted.</remarks>
    function LastIndexOf(const AValue: T): NativeInt; overload;

    ///  <summary>Specifies the number of elements in the list.</summary>
    ///  <returns>A positive value specifying the number of elements in the list.</returns>
    property Count: NativeUInt read FLength;

    ///  <summary>Specifies the current capacity.</summary>
    ///  <returns>A positive number that specifies the number of elements that the list can hold before it
    ///  needs to grow again.</returns>
    ///  <remarks>The value of this property is greater or equal to the amount of elements in the list. If this value
    ///  if greater then the number of elements, it means that the list has some extra capacity to operate upon.</remarks>
    property Capacity: NativeUInt read GetCapacity;

    ///  <summary>Returns the item from a given index.</summary>
    ///  <param name="AIndex">The index in the collection.</param>
    ///  <returns>The element at the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    property Items[const AIndex: NativeUInt]: T read GetItem; default;

    ///  <summary>Returns a new enumerator object used to enumerate this list.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the list.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<T>; override;

    ///  <summary>Removes the excess capacity from the list.</summary>
    ///  <remarks>This method can be called manually to force the list to drop the extra capacity it might hold. For example,
    ///  after performing some massive operations of a big list, call this method to ensure that all extra memory held by the
    ///  list is released.</remarks>
    procedure Shrink();

    ///  <summary>Forces the list to increase its capacity.</summary>
    ///  <remarks>Call this method to force the list to increase its capacity ahead of time. Manually adjusting the capacity
    ///  can be useful in certain situations.</remarks>
    procedure Grow();

    ///  <summary>Copies the specified elements into a new list.</summary>
    ///  <param name="AStartIndex">The index to from which the copy starts.</param>
    ///  <param name="ACount">The number of elements to copy.</param>
    ///  <returns>A new list containing the copied elements.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException">Parameter combination is invalid.</exception>
    function Copy(const AStartIndex: NativeUInt; const ACount: NativeUInt): TSortedList<T>; overload;

    ///  <summary>Copies the specified elements into a new list.</summary>
    ///  <param name="AStartIndex">The index to from which the copy starts.</param>
    ///  <returns>A new list containing the copied elements.</returns>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    function Copy(const AStartIndex: NativeUInt): TSortedList<T>; overload;

    ///  <summary>Creates a copy of this list.</summary>
    ///  <returns>A new list containing the copied elements.</returns>
    function Copy(): TSortedList<T>; overload;

    ///  <summary>Copies the values stored in the list to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the list.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the list.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of T; const AStartIndex: NativeUInt); overload; override;

    ///  <summary>Checks whether the list is empty.</summary>
    ///  <returns><c>True</c> if the list is empty; <c>False</c> otherwise.</returns>
    ///  <remarks>This method is the recommended way of detecting if the list is empty.</remarks>
    function Empty(): Boolean; override;

    ///  <summary>Returns the biggest element.</summary>
    ///  <returns>An element from the list considered to have the biggest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function Max(): T; override;

    ///  <summary>Returns the smallest element.</summary>
    ///  <returns>An element from the list considered to have the smallest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function Min(): T; override;

    ///  <summary>Returns the first element.</summary>
    ///  <returns>The first element in the list.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function First(): T; override;

    ///  <summary>Returns the first element or a default if the list is empty.</summary>
    ///  <param name="ADefault">The default value returned if the list is empty.</param>
    ///  <returns>The first element in list if the list is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function FirstOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the last element.</summary>
    ///  <returns>The last element in the list.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function Last(): T; override;

    ///  <summary>Returns the last element or a default if the list is empty.</summary>
    ///  <param name="ADefault">The default value returned if the list is empty.</param>
    ///  <returns>The last element in list if the list is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function LastOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the single element stored in the list.</summary>
    ///  <returns>The element in list.</returns>
    ///  <remarks>This method checks if the list contains just one element, in which case it is returned.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionNotOneException">There is more than one element in the list.</exception>
    function Single(): T; override;

    ///  <summary>Returns the single element stored in the list, or a default value.</summary>
    ///  <param name="ADefault">The default value returned if there is less or more elements in the list.</param>
    ///  <returns>The element in the list if the condition is satisfied; <paramref name="ADefault"/> is returned otherwise.</returns>
    ///  <remarks>This method checks if the list contains just one element, in which case it is returned. Otherwise
    ///  the value in <paramref name="ADefault"/> is returned.</remarks>
    function SingleOrDefault(const ADefault: T): T; override;

    ///  <summary>Aggregates a value based on the list's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <returns>A value that contains the list's aggregated value.</returns>
    ///  <remarks>This method returns the first element if the list only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    function Aggregate(const AAggregator: TFunc<T, T, T>): T; override;

    ///  <summary>Aggregates a value based on the list's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <param name="ADefault">The default value returned if the list is empty.</param>
    ///  <returns>A value that contains the list's aggregated value. If the list is empty, <paramref name="ADefault"/> is returned.</returns>
    ///  <remarks>This method returns the first element if the list only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    function AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <returns>The element from the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The list is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    function ElementAt(const AIndex: NativeUInt): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <param name="ADefault">The default value returned if the list is empty.</param>
    ///  <returns>The element from the specified position if the list is not empty and the position is not out of bounds; otherwise
    ///  the value of <paramref name="ADefault"/> is returned.</returns>
    function ElementAtOrDefault(const AIndex: NativeUInt; const ADefault: T): T; override;

    ///  <summary>Check whether at least one element in the list satisfies a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if the at least one element satisfies a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole list and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>True</c>. The logical equivalent of this operation is "OR".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function Any(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks that all elements in the list satisfy a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if all elements satisfy a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole list and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>False</c>. The logical equivalent of this operation is "AND".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function All(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks whether the elements in this list are equal to the elements in another collection.</summary>
    ///  <param name="ACollection">The collection to compare to.</param>
    ///  <returns><c>True</c> if the collections are equal; <c>False</c> if the collections are different.</returns>
    ///  <remarks>This methods checks that each element at position X in this list is equal to an element at position X in
    ///  the provided collection. If the number of elements in both collections are different, then the collections are considered different.
    ///  Note that comparison of element is done using the type object used by this list. This means that comparing this collection
    ///  to another one might yeild a different result than comparing the other collection to this one.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    function EqualsTo(const ACollection: IEnumerable<T>): Boolean; override;
  end;

  ///  <summary>The generic <c>sorted list</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses an internal array to store its objects.</remarks>
  TObjectSortedList<T: class> = class(TSortedList<T>)
  private
    FOwnsObjects: Boolean;

  protected
    //TODO: doc me.
    procedure HandleElementRemoved(const AElement: T); override;

  public
    ///  <summary>Specifies whether this list owns the objects stored in it.</summary>
    ///  <returns><c>True</c> if the list owns its objects; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the list controls the life-time of the stored objects.</remarks>
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

type
  { Forward declaration }
  TLinkedList<T> = class;

  { Generic Linked List Node }
  //TODO: doc me
  TLinkedListNode<T> = class
  private
    FRemoved: Boolean;
    FData: T;
    FNext: TLinkedListNode<T>;
    FPrev: TLinkedListNode<T>;
    FList: TLinkedList<T>;

  public
    { Constructors }
    //TODO: doc me
    constructor Create(Value: T);

    { Destructors }
    //TODO: doc me
    destructor Destroy(); override;

    { Properties }
    //TODO: doc me
    property Next: TLinkedListNode<T> read FNext;
    //TODO: doc me
    property Previous: TLinkedListNode<T> read FPrev;

    //TODO: doc me
    property List: TLinkedList<T> read FList;
    //TODO: doc me
    property Value: T read FData write FData;
  end;

  { Generic Linked List }
  TLinkedList<T> = class(TEnexCollection<T>)
  type
    { Generic Linked List Enumerator }
    TEnumerator = class(TEnumerator<T>)
    private
      FVer: NativeUInt;
      FLinkedList: TLinkedList<T>;
      FCurrentNode: TLinkedListNode<T>;

    public
      { Constructor }
      constructor Create(const AList: TLinkedList<T>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): T; override;
      function MoveNext(): Boolean; override;
    end;

  var
    FFirst: TLinkedListNode<T>;
    FLast: TLinkedListNode<T>;
    FCount: NativeUInt;
    FVer : NativeUInt;
  protected
    //TODO: doc me
    function GetCount(): NativeUInt; override;
  public
    { Constructors }
    //TODO: doc me
    constructor Create(); overload;
    //TODO: doc me
    constructor Create(const AEnumerable: IEnumerable<T>); overload;
    //TODO: doc me
    constructor Create(const AArray: array of T); overload;

    //TODO: doc me
    constructor Create(const ARules: TRules<T>); overload;
    //TODO: doc me
    constructor Create(const ARules: TRules<T>; const AEnumerable: IEnumerable<T>); overload;
    //TODO: doc me
    constructor Create(const ARules: TRules<T>; const AArray: array of T); overload;

    { Destructors }
    //TODO: doc me
    destructor Destroy(); override;

    { Adding }
    //TODO: doc me
    procedure AddAfter(const ARefNode: TLinkedListNode<T>; const ANode: TLinkedListNode<T>); overload;
    //TODO: doc me
    procedure AddAfter(const ARefNode: TLinkedListNode<T>; const AValue: T); overload;
    //TODO: doc me
    procedure AddAfter(const ARefValue: T; const AValue: T); overload;

    //TODO: doc me
    procedure AddBefore(const ARefNode: TLinkedListNode<T>; const ANode: TLinkedListNode<T>); overload;
    //TODO: doc me
    procedure AddBefore(const ARefNode: TLinkedListNode<T>; const AValue: T); overload;
    //TODO: doc me
    procedure AddBefore(const ARefValue: T; const AValue: T); overload;

    //TODO: doc me
    procedure AddFirst(const ANode: TLinkedListNode<T>); overload;
    //TODO: doc me
    procedure AddFirst(const AValue: T); overload;

    //TODO: doc me
    procedure AddLast(const ANode: TLinkedListNode<T>); overload;
    //TODO: doc me
    procedure AddLast(const AValue: T); overload;

    { Removing }
    //TODO: doc me
    procedure Clear();

    { All kind of cool removal options }
    //TODO: doc me
    procedure Remove(const AValue: T); overload;
    //TODO: doc me
    procedure RemoveFirst();
    //TODO: doc me
    procedure RemoveLast();

    //TODO: doc me
    function RemoveAndReturnFirst(): T;
    //TODO: doc me
    function RemoveAndReturnLast(): T;

    { Lookup }
    //TODO: doc me
    function Contains(const AValue: T): Boolean;
    //TODO: doc me
    function Find(const AValue: T): TLinkedListNode<T>;
    //TODO: doc me
    function FindLast(const AValue: T): TLinkedListNode<T>;

    { Properties }
    //TODO: doc me
    property Count: NativeUInt read FCount;
    //TODO: doc me
    property FirstNode: TLinkedListNode<T> read FFirst;
    //TODO: doc me
    property LastNode : TLinkedListNode<T> read FLast;

    { ICollection/IEnumerable Support  }
    //TODO: doc me
    procedure CopyTo(var AArray: array of T; const StartIndex: NativeUInt); overload; override;

    //TODO: doc me
    function GetEnumerator(): IEnumerator<T>; override;

    { Enex Overrides }
    //TODO: doc me
    function Empty(): Boolean; override;
    //TODO: doc me
    function Max(): T; override;
    //TODO: doc me
    function Min(): T; override;
    //TODO: doc me
    function First(): T; override;
    //TODO: doc me
    function FirstOrDefault(const ADefault: T): T; override;
    //TODO: doc me
    function Last(): T; override;
    //TODO: doc me
    function LastOrDefault(const ADefault: T): T; override;
    //TODO: doc me
    function Single(): T; override;
    //TODO: doc me
    function SingleOrDefault(const ADefault: T): T; override;
    //TODO: doc me
    function Aggregate(const AAggregator: TFunc<T, T, T>): T; override;
    //TODO: doc me
    function AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T; override;
    //TODO: doc me
    function ElementAt(const Index: NativeUInt): T; override;
    //TODO: doc me
    function ElementAtOrDefault(const Index: NativeUInt; const ADefault: T): T; override;
    //TODO: doc me
    function Any(const APredicate: TFunc<T, Boolean>): Boolean; override;
    //TODO: doc me
    function All(const APredicate: TFunc<T, Boolean>): Boolean; override;
    //TODO: doc me
    function EqualsTo(const AEnumerable: IEnumerable<T>): Boolean; override;
  end;

  { The object variant }
  //TODO: doc me
  TObjectLinkedList<T: class> = class(TLinkedList<T>)
  private
    FOwnsObjects: Boolean;

  protected
    //TODO: doc me.
    procedure HandleElementRemoved(const AElement: T); override;
  public
    { Object owning }
    //TODO: doc me
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

implementation

const
  DefaultArrayLength = 32;

{ TList<T> }

procedure TList<T>.Add(const ACollection: IEnumerable<T>);
begin
  { Call Insert }
  Insert(FLength, ACollection);
end;

function TList<T>.Aggregate(const AAggregator: TFunc<T, T, T>): T;
var
  I: NativeUInt;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Select the first element as comparison base }
  Result := FArray[0];

  { Iterate over the last N - 1 elements }
  for I := 1 to FLength - 1 do
  begin
    { Aggregate a AValue }
    Result := AAggregator(Result, FArray[I]);
  end;
end;

function TList<T>.AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T;
var
  I: NativeUInt;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  if FLength = 0 then
    Exit(ADefault);

  { Select the first element as comparison base }
  Result := FArray[0];

  { Iterate over the last N - 1 elements }
  for I := 1 to FLength - 1 do
  begin
    { Aggregate a AValue }
    Result := AAggregator(Result, FArray[I]);
  end;
end;

function TList<T>.All(const APredicate: TFunc<T, Boolean>): Boolean;
var
  I: NativeUInt;
begin
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  if FLength > 0 then
    for I := 0 to FLength - 1 do
      if not APredicate(FArray[I]) then
        Exit(false);

  Result := true;
end;

function TList<T>.Any(const APredicate: TFunc<T, Boolean>): Boolean;
var
  I: NativeUInt;
begin
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  if FLength > 0 then
    for I := 0 to FLength - 1 do
      if APredicate(FArray[I]) then
        Exit(true);

  Result := false;
end;

procedure TList<T>.Add(const AValue: T);
begin
  { Call Insert }
  Insert(FLength, AValue);
end;

procedure TList<T>.Clear;
var
  I: NativeInt;
begin
  { Should cleanup each element individually }
  for I := 0 to FLength - 1 do
    HandleElementRemoved(FArray[I]);

  { Reset the length }
  FLength := 0;
end;

function TList<T>.Contains(const AValue: T): Boolean;
begin
  { Pass the call to AIndex of }
  Result := (IndexOf(AValue) > -1);
end;

function TList<T>.Copy(const AStartIndex: NativeUInt): TList<T>;
begin
  { Pass the call down to the more generic function }
  Copy(AStartIndex, (FLength - AStartIndex));
end;

function TList<T>.Copy(const AStartIndex, ACount: NativeUInt): TList<T>;
var
  NewList: TList<T>;
  I: NativeInt;
begin
//TODO: redo this function
  { Check for zero elements }
  if (FLength = 0) then
  begin
    Result := TList<T>.Create(ElementRules);
    Exit;
  end;
  
  { Check for indexes }
  if (AStartIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('ACount');

  { Create a new list }
  NewList := TList<T>.Create(ElementRules, ACount);

  { Copy all elements safely }
  for I := 0 to ACount - 1 do
    NewList.FArray[I] := FArray[AStartIndex + I];

  { Set new count }
  NewList.FLength := ACount;
  Result := NewList;
end;

procedure TList<T>.CopyTo(var AArray: array of T; const AStartIndex: NativeUInt);
var
  I: NativeInt;
begin
  { Check for indexes }
  if AStartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (NativeUInt(Length(AArray)) - AStartIndex) < Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  { Copy all elements safely }
  for I := 0 to FLength - 1 do
    AArray[AStartIndex + I] := FArray[I];
end;

constructor TList<T>.Create(const ARules: TRules<T>);
begin
  { Call upper constructor }
  Create(ARules, DefaultArrayLength);
end;

constructor TList<T>.Create(const ARules: TRules<T>;
  const ACollection: IEnumerable<T>);
var
  V: T;
begin
  { Call upper constructor }
  Create(ARules, DefaultArrayLength);

  { Initialize instance }
  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  Add(ACollection);
end;

constructor TList<T>.Create;
begin
  Create(TRules<T>.Default);
end;

constructor TList<T>.Create(const AInitialCapacity: NativeUInt);
begin
  Create(TRules<T>.Default, AInitialCapacity);
end;

constructor TList<T>.Create(const ACollection: IEnumerable<T>);
begin
  Create(TRules<T>.Default, ACollection);
end;

constructor TList<T>.Create(const ARules: TRules<T>;
  const AInitialCapacity: NativeUInt);
begin
  { Call the upper constructor }
  inherited Create(ARules);

  FLength := 0;
  FVer := 0;
  SetLength(FArray, AInitialCapacity);
end;

destructor TList<T>.Destroy;
begin
  { Clear list first }
  Clear();

  inherited;
end;

function TList<T>.ElementAt(const AIndex: NativeUInt): T;
begin
  { Simply use the getter }
  Result := GetItem(AIndex);
end;

function TList<T>.ElementAtOrDefault(const AIndex: NativeUInt; const ADefault: T): T;
begin
  { Check range }
  if (AIndex >= FLength) then
     Result := ADefault
  else
    Result := FArray[AIndex];
end;

function TList<T>.Empty: Boolean;
begin
  Result := (FLength = 0);
end;

function TList<T>.EqualsTo(const ACollection: IEnumerable<T>): Boolean;
var
  V: T;
  I: NativeUInt;
begin
  I := 0;

  for V in ACollection do
  begin
    if I >= FLength then
      Exit(false);

    if not ElementRules.AreEqual(FArray[I], V) then
      Exit(false);

    Inc(I);
  end;

  if I < FLength then
    Exit(false);

  Result := true;
end;

function TList<T>.First: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[0];
end;

function TList<T>.FirstOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else
    Result := FArray[0];
end;

function TList<T>.GetCapacity: NativeUInt;
begin
  Result := Length(FArray);
end;

function TList<T>.GetCount: NativeUInt;
begin
  Result := FLength;
end;

function TList<T>.GetEnumerator: IEnumerator<T>;
begin
  { Create an enumerator }
  Result := TEnumerator.Create(Self);
end;

function TList<T>.GetItem(const AIndex: NativeUInt): T;
begin
  { Check range }
  if (AIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  { Get AValue }
  Result := FArray[AIndex];
end;

procedure TList<T>.Grow;
begin
  { Grow the array }
  if FLength < DefaultArrayLength then
     SetLength(FArray, FLength + DefaultArrayLength)
  else
     SetLength(FArray, FLength * 2);
end;

function TList<T>.IndexOf(const AValue: T): NativeInt;
begin
  { Call more generic function }
  Result := IndexOf(AValue, 0, FLength);
end;

function TList<T>.IndexOf(const AValue: T;
  const AStartIndex: NativeUInt): NativeInt;
begin
  { Call more generic function }
  Result := IndexOf(AValue, AStartIndex, (FLength - AStartIndex));
end;

function TList<T>.IndexOf(const AValue: T; const AStartIndex,
  ACount: NativeUInt): NativeInt;
var
  I: NativeInt;
begin
  Result := -1;

  if FLength = 0 then
     Exit;
  
  { Check for indexes }
  if (AStartIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('ACount');

  { Search for the AValue }
  for I := AStartIndex to ((AStartIndex + ACount) - 1) do
      if ElementRules.AreEqual(FArray[I], AValue) then
      begin
        Result := I;
        Exit;
      end;       
end;

procedure TList<T>.Insert(const AIndex: NativeUInt; const AValue: T);
var
  I  : NativeInt;
  Cap: NativeUInt;
begin
  if AIndex > FLength then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  if FLength = NativeUInt(Length(FArray)) then
    Grow();

  { Move the array to the right }
  if AIndex < FLength then
     for I := FLength downto (AIndex + 1) do
         FArray[I] := FArray[I - 1];

  Inc(FLength);

  { Put the element into the new position }
  FArray[AIndex] := AValue;
  Inc(FVer);
end;

procedure TList<T>.Insert(const AIndex: NativeUInt;
  const ACollection: IEnumerable<T>);
var
  V: T;
  I: NativeInt;
begin
  if AIndex > FLength then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  I := AIndex;
  
  { Enumerate and add }
  for V in ACollection do
  begin
    Insert(I, V);
    Inc(I);
  end;
end;

function TList<T>.LastIndexOf(const AValue: T;
  const AStartIndex: NativeUInt): NativeInt;
begin
  { Call more generic function }
  Result := LastIndexOf(AValue, AStartIndex, (FLength - AStartIndex));
end;

function TList<T>.Last: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[FLength - 1];
end;

function TList<T>.LastIndexOf(const AValue: T): NativeInt;
begin
  { Call more generic function }
  Result := LastIndexOf(AValue, 0, FLength);
end;

function TList<T>.LastOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else
    Result := FArray[FLength - 1];
end;

function TList<T>.Max: T;
var
  I: NativeUInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Result := FArray[0];

  for I := 1 to FLength - 1 do
    if ElementRules.Compare(FArray[I], Result) > 0 then
      Result := FArray[I];
end;

function TList<T>.Min: T;
var
  I: NativeUInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Result := FArray[0];

  for I := 1 to FLength - 1 do
    if ElementRules.Compare(FArray[I], Result) < 0 then
      Result := FArray[I];
end;

procedure TList<T>.QuickSort(ALeft, ARight: NativeInt; const AAscending: Boolean);
begin
  if AAscending then               { Ascending sort }
    QuickSort(ALeft, ARight,
      function(const ALeft, ARight: T): Integer
      begin
        Exit(ElementRules.Compare(ALeft, ARight));
      end
    ) else                        { Descending sort }
    QuickSort(ALeft, ARight,
      function(const ALeft, ARight: T): Integer
      begin
        Exit(-ElementRules.Compare(ALeft, ARight));
      end
    )
end;

procedure TList<T>.QuickSort(ALeft, ARight: NativeInt; const ASortProc: TComparison<T>);
{$IFNDEF OPTIMIZED_SORT}
var
  I, J: NativeInt;
  Pivot, Temp: T;
begin
  ASSERT(Assigned(ASortProc));
  ASSERT(ALeft <= ARight);

  repeat
    I := ALeft;
    J := ARight;

    Pivot := FArray[(ALeft + ARight) div 2];

    repeat
      while ASortProc(FArray[I], Pivot) < 0 do
        Inc(I);

      while ASortProc(FArray[J], Pivot) > 0 do
        Dec(J);

      if I <= J then
      begin

        if I <> J then
        begin
          Temp := FArray[I];
          FArray[I] := FArray[J];
          FArray[J] := Temp;
        end;

        Inc(I);
        Dec(J);
      end;

    until I > J;

    if ALeft < J then
      QuickSort(FArray, ALeft, J, ASortProc);

    ALeft := I;

  until I >= ARight;
end;
{$ELSE}
var
  SubArray, SubLeft, SubRight: NativeInt;
  Pivot, Temp: T;
  Stack: TQuickSortStack;
begin
  ASSERT(Assigned(ASortProc));
  ASSERT(ALeft <= ARight);

  SubArray := 0;

  Stack[SubArray].First := ALeft;
  Stack[SubArray].Last := ARight;

  repeat
    ALeft  := Stack[SubArray].First;
    ARight := Stack[SubArray].Last;
    Dec(SubArray);
    repeat
      SubLeft := ALeft;
      SubRight := ARight;
      Pivot:= FArray[(ALeft + ARight) shr 1];

      repeat
        while ASortProc(FArray[SubLeft], Pivot) < 0 do
          Inc(SubLeft);

        while ASortProc(FArray[SubRight], Pivot) > 0 do
          Dec(SubRight);

        if SubLeft <= SubRight then
        begin
          Temp := FArray[SubLeft];
          FArray[SubLeft] := FArray[SubRight];
          FArray[SubRight] := Temp;
          Inc(SubLeft);
          Dec(SubRight);
        end;
      until SubLeft > SubRight;

      if SubLeft < ARight then
      begin
        Inc(SubArray);
        Stack[SubArray].First := SubLeft;
        Stack[SubArray].Last  := ARight;
      end;

      ARight := SubRight;
    until ALeft >= ARight;
  until SubArray < 0;
end;
{$ENDIF}

function TList<T>.LastIndexOf(const AValue: T; const AStartIndex,
  ACount: NativeUInt): NativeInt;
var
  I: NativeInt;
begin
  Result := -1;

  if FLength = 0 then
     Exit;

  { Check for indexes }
  if (AStartIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('ACount');

  { Search for the AValue }
  for I := ((AStartIndex + ACount) - 1) downto AStartIndex do
      if ElementRules.AreEqual(FArray[I], AValue) then
      begin
        Result := I;
        Exit;
      end;       
end;

procedure TList<T>.Remove(const AValue: T);
var
  I, FoundIndex: NativeInt;
begin
  { Defaults }
  if (FLength = 0) then Exit;
  FoundIndex := -1;

  for I := 0 to FLength - 1 do
  begin
    if ElementRules.AreEqual(FArray[I], AValue) then
    begin
      FoundIndex := I;
      Break;
    end;
  end;

  if FoundIndex > -1 then
  begin
    { Move the list }
    if FLength > 1 then
      for I := FoundIndex to FLength - 2 do
        FArray[I] := FArray[I + 1];

    Dec(FLength);
    Inc(FVer);
  end;
end;

procedure TList<T>.RemoveAt(const AIndex: NativeUInt);
var
  I: NativeInt;
begin
  if AIndex >= FLength then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  if (FLength = 0) then Exit;

  { Cleanup the element at the specified AIndex if required }
  HandleElementRemoved(FArray[AIndex]);

  { Move the list }
  if FLength > 1 then
    for I := AIndex to FLength - 2 do
      FArray[I] := FArray[I + 1];

  Dec(FLength);
  Inc(FVer);
end;

procedure TList<T>.Reverse(const AStartIndex, ACount: NativeUInt);
var
  I: NativeUInt;
  V: T;
begin
  if ACount < 2 then
    Exit;

  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex/ACount');

  { Reverse the array }
  for I := 0 to (ACount div 2) - 1 do
  begin
    V := FArray[AStartIndex + I];
    FArray[AStartIndex + I] := FArray[AStartIndex + ACount - I - 1];
    FArray[AStartIndex + ACount - I - 1] := V;
  end;
end;

procedure TList<T>.Reverse(const AStartIndex: NativeUInt);
begin
  { Call the complete method }
  Reverse(AStartIndex, FLength - AStartIndex);
end;

procedure TList<T>.Reverse;
begin
  { Call the complete method }
  Reverse(0, FLength);
end;

procedure TList<T>.Sort(const AStartIndex, ACount: NativeUInt; const AAscending: Boolean);
begin
  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex/ACount');

  QuickSort(AStartIndex, (AStartIndex + ACount) - 1, AAscending);
end;

procedure TList<T>.Sort(const AStartIndex: NativeUInt; const AAscending: Boolean);
begin
  { Check for indexes }
  if (AStartIndex > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  QuickSort(AStartIndex, (FLength - AStartIndex), AAscending);
end;

procedure TList<T>.SetItem(const AIndex: NativeUInt; const AValue: T);
begin
  { Check range }
  if (AIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  { Get AValue }
  FArray[AIndex] := AValue;
end;

procedure TList<T>.Shrink;
begin
  { Cut the capacity if required }
  if FLength < Capacity then
  begin
    SetLength(FArray, FLength);
  end;
end;

function TList<T>.Single: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError()
  else if FLength > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FArray[0];
end;

function TList<T>.SingleOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else if FLength > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FArray[0];
end;

procedure TList<T>.Sort(const AStartIndex, ACount: NativeUInt; const ASortProc: TComparison<T>);
begin
  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex/ACount');

  QuickSort(AStartIndex, ACount, ASortProc);
end;

procedure TList<T>.Sort(const AStartIndex: NativeUInt; const ASortProc: TComparison<T>);
begin
  { Check for indexes }
  if (AStartIndex > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  QuickSort(AStartIndex, (FLength - AStartIndex), ASortProc)
end;

procedure TList<T>.Sort(const ASortProc: TComparison<T>);
begin
  QuickSort(0, FLength, ASortProc);
end;

procedure TList<T>.Sort(const AAscending: Boolean);
begin
  QuickSort(0, FLength, AAscending);
end;

function TList<T>.Copy: TList<T>;
begin
  { Call a more generic function }
  Result := Copy(0, FLength);
end;

constructor TList<T>.Create(const AArray: array of T);
begin
  Create(TRules<T>.Default, AArray);
end;

constructor TList<T>.Create(const ARules: TRules<T>; const AArray: array of T);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(ARules, DefaultArrayLength);

  { Copy from array }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;

{ TList<T>.TEnumerator }

constructor TList<T>.TEnumerator.Create(const AList: TList<T>);
begin
  { Initialize }
  FList := AList;
  KeepObjectAlive(FList);

  FCurrentIndex := 0;
  FVer := FList.FVer;
end;

destructor TList<T>.TEnumerator.Destroy;
begin
  ReleaseObject(FList);
  inherited;
end;

function TList<T>.TEnumerator.GetCurrent: T;
begin
  if FVer <> FList.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  if FCurrentIndex > 0 then
    Result := FList.FArray[FCurrentIndex - 1]
  else
    Result := default(T);
end;

function TList<T>.TEnumerator.MoveNext: Boolean;
begin
  if FVer <> FList.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FCurrentIndex < FList.FLength;
  Inc(FCurrentIndex);
end;

{ TObjectList<T> }

procedure TObjectList<T>.HandleElementRemoved(const AElement: T);
begin
  TObject(AElement).Free;
end;

{ TSortedList<T> }

procedure TSortedList<T>.Insert(const AIndex: NativeUInt; const AValue: T);
var
  I  : NativeInt;
  Cap: NativeUInt;
begin
  if AIndex > FLength then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  if FLength = NativeUInt(Length(FArray)) then
    Grow();

  { Move the array to the right }
  if AIndex < FLength then
     for I := FLength downto (AIndex + 1) do
         FArray[I] := FArray[I - 1];

  Inc(FLength);

  { Put the element into the new position }
  FArray[AIndex] := AValue;
  Inc(FVer);
end;

procedure TSortedList<T>.Add(const ACollection: IEnumerable<T>);
var
  V: T;
begin
  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Enumerate and add, preserving order}
  for V in ACollection do
    Add(V);
end;

function TSortedList<T>.Aggregate(const AAggregator: TFunc<T, T, T>): T;
var
  I: NativeUInt;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Select the first element as comparison base }
  Result := FArray[0];

  { Iterate over the last N - 1 elements }
  for I := 1 to FLength - 1 do
  begin
    { Aggregate a value }
    Result := AAggregator(Result, FArray[I]);
  end;
end;

function TSortedList<T>.AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T;
var
  I: NativeUInt;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  if FLength = 0 then
    Exit(ADefault);

  { Select the first element as comparison base }
  Result := FArray[0];

  { Iterate over the last N - 1 elements }
  for I := 1 to FLength - 1 do
  begin
    { Aggregate a value }
    Result := AAggregator(Result, FArray[I]);
  end;
end;

function TSortedList<T>.All(const APredicate: TFunc<T, Boolean>): Boolean;
var
  I: NativeUInt;
begin
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  if FLength > 0 then
    for I := 0 to FLength - 1 do
      if not APredicate(FArray[I]) then
        Exit(false);

  Result := true;
end;

function TSortedList<T>.Any(const APredicate: TFunc<T, Boolean>): Boolean;
var
  I: NativeUInt;
begin
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  if FLength > 0 then
    for I := 0 to FLength - 1 do
      if APredicate(FArray[I]) then
        Exit(true);

  Result := false;
end;

procedure TSortedList<T>.Add(const AValue: T);
var
  I: NativeUInt;
  Sign: NativeInt;
begin

  if FAscending then
     Sign := 1
  else
     Sign := -1;

  I := 0;

  while I < FLength do
  begin
    if ((ElementRules.Compare(AValue, FArray[I]) * Sign) < 0) then
       Break;

    Inc(I);
  end;

  Insert(I, AValue);
end;

procedure TSortedList<T>.Clear;
var
  I: NativeInt;
begin
  { Should cleanup each element individually }
  for I := 0 to FLength - 1 do
    HandleElementRemoved(FArray[I]);

  { Reset the length }
  FLength := 0;
end;

function TSortedList<T>.Contains(const AValue: T): Boolean;
begin
  { Pass the call to AIndex of }
  Result := (IndexOf(AValue) > -1);
end;

function TSortedList<T>.Copy(const AStartIndex: NativeUInt): TSortedList<T>;
begin
  { Pass the call down to the more generic function }
  Copy(AStartIndex, (FLength - AStartIndex));
end;

function TSortedList<T>.Copy(const AStartIndex, ACount: NativeUInt): TSortedList<T>;
var
  NewList: TSortedList<T>;
  I: NativeInt;
begin
  //TODO: remake;
  { Check for zero elements }
  if (FLength = 0) then
  begin
    Result := TSortedList<T>.Create(ElementRules);
    Exit;
  end;

  { Check for indexes }
  if (AStartIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('ACount');

  { Create a new list }
  NewList := TSortedList<T>.Create(ElementRules, ACount);

  { Copy all elements safely }
  for I := 0 to ACount - 1 do
    NewList.FArray[I] := FArray[AStartIndex + I];

  { Set new count }
  NewList.FLength := ACount;

  Result := NewList;
end;

function TSortedList<T>.Copy: TSortedList<T>;
begin
  { Pass the call down to the more generic function }
  Copy(0, FLength);
end;

procedure TSortedList<T>.CopyTo(var AArray: array of T; const AStartIndex: NativeUInt);
var
  I: NativeInt;
begin
  { Check for indexes }
  if AStartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (NativeUInt(Length(AArray)) - AStartIndex) < FLength then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  { Copy all elements safely }
  for I := 0 to FLength - 1 do
    AArray[AStartIndex + I] := FArray[I];
end;

constructor TSortedList<T>.Create(const ARules: TRules<T>; const AAscending: Boolean);
begin
  { Call upper constructor }
  Create(ARules, DefaultArrayLength, AAscending);
end;

constructor TSortedList<T>.Create(const ARules: TRules<T>;
  const ACollection: IEnumerable<T>; const AAscending: Boolean);
var
  V: T;
begin
  { Call upper constructor }
  Create(ARules, DefaultArrayLength, AAscending);

  { Initialize instance }
  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Try to copy the given Enumerable }
  for V in ACollection do
  begin
    { Perform a simple push }
    Add(V);
  end;
end;

constructor TSortedList<T>.Create(const AAscending: Boolean);
begin
  Create(TRules<T>.Default, AAscending);
end;

constructor TSortedList<T>.Create(const AInitialCapacity: NativeUInt; const AAscending: Boolean);
begin
  Create(TRules<T>.Default, AInitialCapacity, AAscending);
end;

constructor TSortedList<T>.Create(const ACollection: IEnumerable<T>; const AAscending: Boolean);
begin
  Create(TRules<T>.Default, ACollection, AAscending);
end;

constructor TSortedList<T>.Create(const ARules: TRules<T>;
  const AInitialCapacity: NativeUInt; const AAscending: Boolean);
begin
  { Call the upper constructor }
  inherited Create(ARules);

  FLength := 0;
  FVer := 0;
  FAscending := AAscending;

  SetLength(FArray, AInitialCapacity);
end;

destructor TSortedList<T>.Destroy;
begin
  { Clear list first }
  Clear();

  inherited;
end;

function TSortedList<T>.ElementAt(const AIndex: NativeUInt): T;
begin
  { Simply use the getter }
  Result := GetItem(AIndex);
end;

function TSortedList<T>.ElementAtOrDefault(const AIndex: NativeUInt; const ADefault: T): T;
begin
  { Check range }
  if (AIndex >= FLength) then
     Result := ADefault
  else
    Result := FArray[AIndex];
end;

function TSortedList<T>.Empty: Boolean;
begin
  Result := (FLength = 0);
end;

function TSortedList<T>.EqualsTo(const ACollection: IEnumerable<T>): Boolean;
var
  V: T;
  I: NativeUInt;
begin
  I := 0;

  for V in ACollection do
  begin
    if I >= FLength then
      Exit(false);

    if not ElementRules.AreEqual(FArray[I], V) then
      Exit(false);

    Inc(I);
  end;

  if I < FLength then
    Exit(false);

  Result := true;
end;

function TSortedList<T>.First: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[0];
end;

function TSortedList<T>.FirstOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else
    Result := FArray[0];
end;

function TSortedList<T>.GetCapacity: NativeUInt;
begin
  Result := Length(FArray);
end;

function TSortedList<T>.GetCount: NativeUInt;
begin
  Result := FLength;
end;

function TSortedList<T>.GetEnumerator: IEnumerator<T>;
begin
  { Create an enumerator }
  Result := TEnumerator.Create(Self);
end;

function TSortedList<T>.GetItem(const AIndex: NativeUInt): T;
begin
  { Check range }
  if (AIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  { Get value }
  Result := FArray[AIndex];
end;

procedure TSortedList<T>.Grow;
begin
  { Grow the array }
  if FLength < DefaultArrayLength then
     SetLength(FArray, FLength + DefaultArrayLength)
  else
     SetLength(FArray, FLength * 2);
end;

function TSortedList<T>.IndexOf(const AValue: T): NativeInt;
begin
  { Call more generic function }
  Result := IndexOf(AValue, 0, FLength);
end;

function TSortedList<T>.IndexOf(const AValue: T;
  const AStartIndex: NativeUInt): NativeInt;
begin
  { Call more generic function }
  Result := IndexOf(AValue, AStartIndex, (FLength - AStartIndex));
end;

function TSortedList<T>.BinarySearch(const AElement: T; const AStartIndex, ACount: NativeUInt; AAscending: Boolean): NativeInt;
var
  LLeft, LRight, LMiddle: NativeInt;
  LCompareResult: NativeInt;
begin
  { Do not search for 0 count }
  if ACount = 0 then
  begin
    Result := -1;
    Exit;
  end;

  { Check for valid type support }
  LLeft := AStartIndex;
  LRight := NativeUInt(LLeft) + Count - 1;

  while (LLeft <= LRight) do
  begin
    LMiddle := (LLeft + LRight) div 2;
    LCompareResult := ElementRules.Compare(FArray[LMiddle], AElement);

    if not AAscending then
       LCompareResult := LCompareResult * -1;

    if LCompareResult > 0 then
      LRight := LMiddle - 1
    else if LCompareResult < 0 then
       LLeft := LMiddle + 1
    else
       begin Result := NativeUInt(LMiddle) - AStartIndex; Exit; end;
  end;

  Result := -1;
end;

function TSortedList<T>.IndexOf(const AValue: T; const AStartIndex,
  ACount: NativeUInt): NativeInt;
var
  I, J: NativeInt;
begin
  Result := -1;

  if FLength = 0 then
     Exit;

  { Check for indexes }
  if (AStartIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('ACount');

  { Search for the value }
  J := BinarySearch(AValue, AStartIndex, ACount, FAscending);

  if J = -1 then
     Exit(-1)
  else
    Inc(J, AStartIndex);

  for I := J - 1 downto AStartIndex do
      if not ElementRules.AreEqual(AValue, FArray[I]) then
      begin
        Result := I + 1;
        Exit;
      end;
  Result := J;
end;

function TSortedList<T>.LastIndexOf(const AValue: T;
  const AStartIndex: NativeUInt): NativeInt;
begin
  { Call more generic function }
  Result := LastIndexOf(AValue, AStartIndex, (FLength - AStartIndex));
end;

function TSortedList<T>.Last: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[FLength - 1];
end;

function TSortedList<T>.LastIndexOf(const AValue: T): NativeInt;
begin
  { Call more generic function }
  Result := LastIndexOf(AValue, 0, FLength);
end;

function TSortedList<T>.LastOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else
    Result := FArray[FLength - 1];
end;

function TSortedList<T>.Max: T;
var
  I: NativeUInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Result := FArray[0];

  for I := 1 to FLength - 1 do
    if ElementRules.Compare(FArray[I], Result) > 0 then
      Result := FArray[I];
end;

function TSortedList<T>.Min: T;
var
  I: NativeUInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Result := FArray[0];

  for I := 1 to FLength - 1 do
    if ElementRules.Compare(FArray[I], Result) < 0 then
      Result := FArray[I];
end;

function TSortedList<T>.LastIndexOf(const AValue: T; const AStartIndex,
  ACount: NativeUInt): NativeInt;
var
  I, J: NativeInt;
begin
  Result := -1;

  if FLength = 0 then
     Exit;

  { Check for indexes }
  if (AStartIndex >= FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  { Check for indexes }
  if ((AStartIndex + ACount) > FLength) then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('ACount');

  { Search for the value }
  J := BinarySearch(AValue, AStartIndex, ACount, FAscending);

  if J = -1 then
     Exit(-1)
  else
    Inc(J, AStartIndex);

  for I := J + 1 to AStartIndex + ACount - 1 do
    if not ElementRules.AreEqual(AValue, FArray[I]) then
    begin
      Result := I - 1;
      Exit;
    end;

  Result := J;
end;

procedure TSortedList<T>.Remove(const AValue: T);
var
  I, FoundIndex: NativeInt;
begin
  { Defaults }
  if (FLength = 0) then Exit;
  FoundIndex := -1;

  for I := 0 to FLength - 1 do
  begin
    if ElementRules.AreEqual(FArray[I], AValue) then
    begin
      FoundIndex := I;
      Break;
    end;
  end;

  if FoundIndex > -1 then
  begin
    { Move the list }
    if FLength > 1 then
      for I := FoundIndex to FLength - 2 do
        FArray[I] := FArray[I + 1];

    Dec(FLength);
    Inc(FVer);
  end;
end;

procedure TSortedList<T>.RemoveAt(const AIndex: NativeUInt);
var
  I: NativeInt;
begin
  if AIndex >= FLength then
     ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  if (FLength = 0) then Exit;

  { Clanup the element at the specified AIndex if required }
  HandleElementRemoved(FArray[AIndex]);

  { Move the list }
  if FLength > 1 then
    for I := AIndex to FLength - 2 do
      FArray[I] := FArray[I + 1];

  Dec(FLength);
  Inc(FVer);
end;

procedure TSortedList<T>.Shrink;
begin
  { Cut the capacity if required }
  if FLength < Capacity then
  begin
    SetLength(FArray, FLength);
  end;
end;

function TSortedList<T>.Single: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError()
  else if FLength > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FArray[0];
end;

function TSortedList<T>.SingleOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else if FLength > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FArray[0];
end;

constructor TSortedList<T>.Create(const AArray: array of T; const AAscending: Boolean);
begin
  Create(TRules<T>.Default, AArray, AAscending);
end;

constructor TSortedList<T>.Create(const ARules: TRules<T>; const AArray: array of T; const AAscending: Boolean);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(ARules, DefaultArrayLength, AAscending);

  { Copy from array }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;

{ TSortedList<T>.TEnumerator }

constructor TSortedList<T>.TEnumerator.Create(const AList: TSortedList<T>);
begin
  { Initialize }
  FList := AList;
  KeepObjectAlive(FList);

  FCurrentIndex := 0;
  FVer := FList.FVer;
end;

destructor TSortedList<T>.TEnumerator.Destroy;
begin
  ReleaseObject(FList);
  inherited;
end;

function TSortedList<T>.TEnumerator.GetCurrent: T;
begin
  if FVer <> FList.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  if FCurrentIndex > 0 then
    Result := FList.FArray[FCurrentIndex - 1]
  else
    Result := default(T);
end;

function TSortedList<T>.TEnumerator.MoveNext: Boolean;
begin
  if FVer <> FList.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FCurrentIndex < FList.FLength;
  Inc(FCurrentIndex);
end;

{ TObjectSortedList<T> }

procedure TObjectSortedList<T>.HandleElementRemoved(const AElement: T);
begin
  TObject(AElement).Free;
end;

{ TSimpleLinkedListNode<T> }

constructor TLinkedListNode<T>.Create(Value: T);
begin
  { Assign the value }
  FData := Value;

  { Initialize internals to nil }
  FPrev := nil;
  FNext := nil;
  FList := nil;
end;

destructor TLinkedListNode<T>.Destroy;
begin

  { Link the parent with the next and skip me! }
  if (FPrev <> nil) then
  begin
    FPrev.FNext := FNext;

    { Chnage the last element if required }
    if (FNext = nil) and (FList <> nil) then
       FList.FLast := FPrev;
  end else
  begin
    { This is the first element - update parent list }
    if (FList <> nil) then
       FList.FFirst := FNext;
  end;

  { Update back link }
  if (FNext <> nil) then
     FNext.FPrev := FPrev;

  { Changethe value of the count property in the parent list }
  if (FList <> nil) then
  begin
    { Clean myself up }
    if not FRemoved then
      FList.HandleElementRemoved(FData);

    Dec(FList.FCount);
    Inc(FList.FVer);
  end;

  { Manually assign last value }
  if FList.FCount = 0 then
     FList.FLast := nil;

  inherited;
end;

{ TLinkedList<T> }

procedure TLinkedList<T>.AddAfter(const ARefNode: TLinkedListNode<T>; const AValue: T);
begin
  { Re-route }
  AddAfter(ARefNode, TLinkedListNode<T>.Create(AValue));
end;

procedure TLinkedList<T>.AddAfter(const ARefNode: TLinkedListNode<T>; const ANode: TLinkedListNode<T>);
var
  Current: TLinkedListNode<T>;
begin
  if ARefNode = nil then
     ExceptionHelper.Throw_ArgumentNilError('ARefNode');

  if ANode = nil then
     ExceptionHelper.Throw_ArgumentNilError('ANode');

  if ARefNode.FList <> Self then
     ExceptionHelper.Throw_ElementNotPartOfCollectionError('ARefNode');

  if ANode.FList <> nil then
     ExceptionHelper.Throw_ElementAlreadyPartOfCollectionError('ANode');

  { Test for immediate value }
  if (FFirst = nil) then Exit;

  { Start value }
  Current := FFirst;

  while Current <> nil do
  begin

    if (Current = ARefNode) then
    begin
      ANode.FPrev := Current;
      ANode.FNext := Current.FNext;
      Current.FNext := ANode;

      if (ANode.FNext <> nil) then
          ANode.FNext.FPrev := ANode
      else
          FLast := ANode;

      Inc(FCount);
      Inc(FVer);
      ANode.FList := Self;

      Exit;
    end;

    Current := Current.FNext;
  end;
end;

procedure TLinkedList<T>.AddBefore(const ARefNode: TLinkedListNode<T>; const AValue: T);
begin
  { Re-route }
  AddBefore(ARefNode, TLinkedListNode<T>.Create(AValue));
end;

procedure TLinkedList<T>.AddBefore(const ARefNode: TLinkedListNode<T>; const ANode: TLinkedListNode<T>);
var
  Current: TLinkedListNode<T>;
begin
  if ARefNode = nil then
     ExceptionHelper.Throw_ArgumentNilError('ARefNode');

  if ANode = nil then
     ExceptionHelper.Throw_ArgumentNilError('ANode');

  if ARefNode.FList <> Self then
     ExceptionHelper.Throw_ElementNotPartOfCollectionError('ARefNode');

  if ANode.FList <> nil then
     ExceptionHelper.Throw_ElementAlreadyPartOfCollectionError('ANode');

  { Test for immediate value }
  if (FFirst = nil) then Exit;

  { Start value }
  Current := FFirst;

  while Current <> nil do
  begin

    if (Current = ARefNode) then
    begin
      ANode.FNext := Current;
      ANode.FPrev := Current.FPrev;
      Current.FPrev := ANode;

      if ANode.FPrev <> nil then
         ANode.FPrev.FNext := ANode;

      Inc(FCount);
      Inc(FVer);

      ANode.FList := Self;

      if Current = FFirst then
         FFirst := ANode;

      Exit;
    end;

    Current := Current.FNext;
  end;
end;

procedure TLinkedList<T>.AddFirst(const AValue: T);
begin
  { Re-route }
  AddFirst(TLinkedListNode<T>.Create(AValue));
end;

procedure TLinkedList<T>.AddFirst(const ANode: TLinkedListNode<T>);
begin
  if ANode = nil then
     ExceptionHelper.Throw_ArgumentNilError('ANode');

  if ANode.FList <> nil then
     ExceptionHelper.Throw_ElementAlreadyPartOfCollectionError('ANode');

  { Plug in the new node }
  ANode.FNext := FFirst;

  if FFirst <> nil then
     FFirst.FPrev := ANode;

  FFirst := ANode;

  if (FLast = nil) then
      FLast := FFirst;

  ANode.FList := Self;

  Inc(FCount);
  Inc(FVer);
end;

procedure TLinkedList<T>.AddLast(const AValue: T);
begin
  { Re-route }
  AddLast(TLinkedListNode<T>.Create(AValue));
end;

function TLinkedList<T>.Aggregate(const AAggregator: TFunc<T, T, T>): T;
var
  Node: TLinkedListNode<T>;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  { Check length }
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Node := FFirst;
  Result := Node.FData;

  while True do
  begin
    Node := Node.FNext;

    if Node = nil then
      Exit;

    { Aggregate a value }
    Result := AAggregator(Result, Node.FData);
  end;
end;

function TLinkedList<T>.AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T;
var
  Node: TLinkedListNode<T>;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  { Check length }
  if FCount = 0 then
    Exit(ADefault);

  { Default one }
  Node := FFirst;
  Result := Node.FData;

  while True do
  begin
    Node := Node.FNext;

    if Node = nil then
      Exit;

    { Aggregate a value }
    Result := AAggregator(Result, Node.FData);
  end;
end;

function TLinkedList<T>.All(const APredicate: TFunc<T, Boolean>): Boolean;
var
  Node: TLinkedListNode<T>;
begin
  { Check arguments }
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  { Default one }
  Node := FFirst;
  while Node <> nil do
  begin
    if not APredicate(Node.FData) then
      Exit(false);

    Node := Node.FNext;
  end;

  Result := true;
end;

function TLinkedList<T>.Any(const APredicate: TFunc<T, Boolean>): Boolean;
var
  Node: TLinkedListNode<T>;
begin
  { Check arguments }
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  { Default one }
  Node := FFirst;
  while Node <> nil do
  begin
    if APredicate(Node.FData) then
      Exit(true);

    Node := Node.FNext;
  end;

  Result := false;
end;

procedure TLinkedList<T>.AddLast(const ANode: TLinkedListNode<T>);
begin
  if ANode = nil then
     ExceptionHelper.Throw_ArgumentNilError('ANode');

  if ANode.FList <> nil then
     ExceptionHelper.Throw_ElementAlreadyPartOfCollectionError('ANode');

  { Plug in the new node }
  ANode.FPrev := FLast;

  if FLast <> nil then
     FLast.FNext := ANode;

  FLast := ANode;

  if (FFirst = nil) then
      FFirst := FLast;

  ANode.FList := Self;

  Inc(FCount);
  Inc(FVer);
end;

procedure TLinkedList<T>.Clear;
begin
  { Delete one-by-one }
  while FFirst <> nil do
        FFirst.Free();
end;

function TLinkedList<T>.Contains(const AValue: T): Boolean;
begin
  { Simply re-route }
  Result := (Find(AValue) <> nil);
end;

procedure TLinkedList<T>.CopyTo(var AArray: array of T;
  const StartIndex: NativeUInt);
var
  Current: TLinkedListNode<T>;
  Index  : NativeUInt;
begin
  if StartIndex >= NativeUInt(Length(AArray)) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('StartIndex');

  if (NativeUInt(Length(AArray)) - StartIndex) < FCount then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  { Test for immediate value }
  if (FFirst = nil) then Exit;

  { Start value }
  Current := FFirst;
  Index := StartIndex;

  while Current <> nil do
  begin
    AArray[Index] := Current.Value;
    Current := Current.FNext;
    Inc(Index);
  end;
end;

constructor TLinkedList<T>.Create;
begin
  Create(TRules<T>.Default);
end;

constructor TLinkedList<T>.Create(const AEnumerable: IEnumerable<T>);
begin
  Create(TRules<T>.Default, AEnumerable);
end;

constructor TLinkedList<T>.Create(const ARules: TRules<T>);
begin
  { Call the upper constructor }
  inherited Create(ARules);

  FFirst := nil;
  FLast := nil;
  FCount := 0;
  FVer := 0;
end;

constructor TLinkedList<T>.Create(const ARules: TRules<T>;
  const AEnumerable: IEnumerable<T>);
var
  V: T;
begin
  { Call upper constructor }
  Create(ARules);

  if (AEnumerable = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AEnumerable');

  { Try to copy the given Enumerable }
  for V in AEnumerable do
  begin
    { Perform a simple copy }
    AddLast(V);
  end;
end;

function TLinkedList<T>.GetCount: NativeUInt;
begin
  Result := FCount;
end;

function TLinkedList<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Self);
end;

function TLinkedList<T>.Last: T;
begin
  { Check length }
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FLast.FData;
end;

function TLinkedList<T>.LastOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FCount = 0 then
    Result := ADefault
  else
    Result := FLast.FData;
end;

function TLinkedList<T>.Max: T;
var
  Node: TLinkedListNode<T>;
begin
  { Check length }
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Node := FFirst;
  Result := Node.FData;

  while True do
  begin
    Node := Node.FNext;

    if Node = nil then
      Exit;

    if ElementRules.Compare(Node.FData, Result) > 0 then
      Result := Node.FData;
  end;
end;

function TLinkedList<T>.Min: T;
var
  Node: TLinkedListNode<T>;
begin
  { Check length }
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Node := FFirst;
  Result := Node.FData;

  while True do
  begin
    Node := Node.FNext;

    if Node = nil then
      Exit;

    if ElementRules.Compare(Node.FData, Result) < 0 then
      Result := Node.FData;
  end;
end;

destructor TLinkedList<T>.Destroy;
begin
  { Clear the list first }
  Clear();

  inherited;
end;

function TLinkedList<T>.ElementAt(const Index: NativeUInt): T;
var
  Node: TLinkedListNode<T>;
  I: NativeUInt;
begin
  { Default one }
  Node := FFirst;
  I := 0;

  while Node <> nil do
  begin
    if I = Index then
      Exit(Node.FData);

    Node := Node.FNext;
    Inc(I);
  end;

  ExceptionHelper.Throw_ArgumentOutOfRangeError('Index');
end;

function TLinkedList<T>.ElementAtOrDefault(const Index: NativeUInt; const ADefault: T): T;
var
  Node: TLinkedListNode<T>;
  I: NativeUInt;
begin
  { Default one }
  Node := FFirst;
  I := 0;

  while Node <> nil do
  begin
    if I = Index then
      Exit(Node.FData);

    Node := Node.FNext;
    Inc(I);
  end;

  Result := ADefault;
end;

function TLinkedList<T>.Empty: Boolean;
begin
  Result := (FCount = 0);
end;

function TLinkedList<T>.EqualsTo(const AEnumerable: IEnumerable<T>): Boolean;
var
  Node: TLinkedListNode<T>;
  V: T;
begin
  Node := FFirst;

  for V in AEnumerable do
  begin
    if Node = nil then
      Exit(false);

    if not ElementRules.AreEqual(Node.FData, V) then
      Exit(false);

    Node := Node.FNext;
  end;

  if Node <> nil then
    Exit(false);

  Result := true;
end;

function TLinkedList<T>.Find(const AValue: T): TLinkedListNode<T>;
var
  Current: TLinkedListNode<T>;
begin
  Result := nil;

  { Test for immediate value }
  if (FFirst = nil) then Exit;

  { Start value }
  Current := FFirst;

  while Current <> nil do
  begin

    if ElementRules.AreEqual(Current.FData, AValue) then
    begin
      Result := Current;
      exit;
    end;

    Current := Current.FNext;
  end;

end;

function TLinkedList<T>.FindLast(const AValue: T): TLinkedListNode<T>;
var
  Current: TLinkedListNode<T>;
begin
  Result := nil;

  { Test for immediate value }
  if (FLast = nil) then Exit;

  { Start value }
  Current := FLast;

  while Current <> nil do
  begin

    if ElementRules.AreEqual(Current.FData, AValue) then
    begin
      Result := Current;
      exit;
    end;

    Current := Current.FPrev;
  end;

end;

function TLinkedList<T>.First: T;
begin
  { Check length }
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FFirst.FData;
end;

function TLinkedList<T>.FirstOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FCount = 0 then
    Result := ADefault
  else
    Result := FFirst.FData;
end;

procedure TLinkedList<T>.Remove(const AValue: T);
var
  FoundNode: TLinkedListNode<T>;
begin
  { Find the node }
  FoundNode := Find(AValue);

  { Free if found }
  if (FoundNode <> nil) then
  begin
    FoundNode.FRemoved := true;
    FoundNode.Free();
  end;
end;

function TLinkedList<T>.RemoveAndReturnFirst: T;
begin
  { Check if there is a First and remove it }
  if FFirst <> nil then
  begin
    FFirst.FRemoved := true;
    Result := FFirst.FData;

    FFirst.Free;
  end else
    ExceptionHelper.Throw_CollectionEmptyError();
end;

function TLinkedList<T>.RemoveAndReturnLast: T;
begin
  { Check if there is a Last and remove it }
  if FLast <> nil then
  begin
    FLast.FRemoved := true;
    Result := FLast.FData;

    FLast.Free;
  end else
    ExceptionHelper.Throw_CollectionEmptyError();
end;

procedure TLinkedList<T>.RemoveFirst;
begin
  { Check if there is a First and remove it }
  if FFirst <> nil then
     FFirst.Free();
end;

procedure TLinkedList<T>.RemoveLast;
begin
  { Check if there is a First and remove it }
  if FLast <> nil then
     FLast.Free();
end;

function TLinkedList<T>.Single: T;
begin
  { Check length }
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError()
  else if FCount > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FFirst.FData;
end;

function TLinkedList<T>.SingleOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FCount = 0 then
    Result := ADefault
  else if FCount > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FFirst.FData;
end;

procedure TLinkedList<T>.AddAfter(const ARefValue, AValue: T);
var
  FoundNode: TLinkedListNode<T>;
begin
  { Find the node }
  FoundNode := Find(ARefValue);

  if FoundNode = nil then
     ExceptionHelper.Throw_ElementNotPartOfCollectionError('ARefValue');

  AddAfter(FoundNode, TLinkedListNode<T>.Create(AValue));
end;

procedure TLinkedList<T>.AddBefore(const ARefValue, AValue: T);
var
  FoundNode: TLinkedListNode<T>;
begin
  { Find the node }
  FoundNode := Find(ARefValue);

  if FoundNode = nil then
     ExceptionHelper.Throw_ElementNotPartOfCollectionError('ARefValue');

  AddBefore(FoundNode, TLinkedListNode<T>.Create(AValue));
end;

constructor TLinkedList<T>.Create(const AArray: array of T);
begin
  Create(TRules<T>.Default, AArray);
end;

constructor TLinkedList<T>.Create(const ARules: TRules<T>; const AArray: array of T);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(ARules);

  { Copy from array }
  for I := 0 to Length(AArray) - 1 do
  begin
    AddLast(AArray[I]);
  end;
end;

{ TLinkedList<T>.TEnumerator }

constructor TLinkedList<T>.TEnumerator.Create(const AList: TLinkedList<T>);
begin
  { Initialize }
  FLinkedList := AList;
  KeepObjectAlive(FLinkedList);

  FCurrentNode := nil;
  FVer := AList.FVer;
end;

destructor TLinkedList<T>.TEnumerator.Destroy;
begin
  ReleaseObject(FLinkedList);
  inherited;
end;

function TLinkedList<T>.TEnumerator.GetCurrent: T;
begin
  if FVer <> FLinkedList.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  if FCurrentNode <> nil then
     Result := FCurrentNode.FData
  else
     Result := default(T);
end;

function TLinkedList<T>.TEnumerator.MoveNext: Boolean;
begin
  if FVer <> FLinkedList.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  if FCurrentNode = nil then
     FCurrentNode := FLinkedList.FirstNode
  else
     FCurrentNode := FCurrentNode.FNext;

  Result := (FCurrentNode <> nil);
end;

{ TObjectLinkedList<T> }

procedure TObjectLinkedList<T>.HandleElementRemoved(const AElement: T);
begin
  TObject(AElement).Free;
end;

end.
