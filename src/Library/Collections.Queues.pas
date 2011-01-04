(*
* Copyright (c) 2008-2011, Ciobanu Alexandru
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

unit Collections.Queues;
interface
uses SysUtils,
     Generics.Collections,
     Collections.Lists,
     Collections.Base;

type
  ///  <summary>The generic <c>queue (FIFO)</c> collection.</summary>
  ///  <remarks>This type uses an internal array to store its values.</remarks>
  TQueue<T> = class(TEnexCollection<T>, IQueue<T>, IDynamic)
  private type
    {$REGION 'Internal Types'}
    TEnumerator = class(TEnumerator<T>)
    private
      FVer: NativeInt;
      FQueue: TQueue<T>;
      FElement: T;
      FCount, FHead: NativeInt;

    public
      { Constructor }
      constructor Create(const AQueue : TQueue<T>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): T; override;
      function MoveNext(): Boolean; override;
    end;
    {$ENDREGION}

  private var
    FVer: NativeInt;
    FHead: NativeInt;
    FTail: NativeInt;
    FLength: NativeInt;
    FArray: TArray<T>;

    procedure SetCapacity(const ANewCapacity : NativeInt);
  protected
    ///  <summary>Returns the number of elements in the queue.</summary>
    ///  <returns>A positive value specifying the number of elements in the queue.</returns>
    function GetCount(): NativeInt; override;

    ///  <summary>Returns the current capacity.</summary>
    ///  <returns>A positive number that specifies the number of elements that the queue can hold before it
    ///  needs to grow again.</returns>
    ///  <remarks>The value of this method is greater or equal to the amount of elements in the queue. If this value
    ///  is greater then the number of elements, it means that the queue has some extra capacity to operate upon.</remarks>
    function GetCapacity(): NativeInt;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The queue's initial capacity.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AInitialCapacity: NativeInt); overload;

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
    ///  <param name="AInitialCapacity">The queue's initial capacity.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AInitialCapacity: NativeInt); overload;

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
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the queue.</summary>
    ///  <remarks>This method clears the queue and invokes type object's cleaning routines for each element.</remarks>
    procedure Clear();

    ///  <summary>Appends an element to the top of the queue.</summary>
    ///  <param name="AValue">The value to append.</param>
    procedure Enqueue(const AValue: T);

    ///  <summary>Retreives the element from the bottom of the queue.</summary>
    ///  <returns>The value at the bottom of the queue.</returns>
    ///  <remarks>This method removes the element from the bottom of the queue.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Dequeue(): T;

    ///  <summary>Reads the element from the bottom of the queue.</summary>
    ///  <returns>The value at the bottom of the queue.</returns>
    ///  <remarks>This method does not remove the element from the bottom of the queue. It merely reads it's value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Peek(): T;

    ///  <summary>Checks whether the queue contains a given value.</summary>
    ///  <param name="AValue">The value to check.</param>
    ///  <returns><c>True</c> if the value was found in the queue; <c>False</c> otherwise.</returns>
    function Contains(const AValue: T): Boolean;

    ///  <summary>Specifies the number of elements in the queue.</summary>
    ///  <returns>A positive value specifying the number of elements in the queue.</returns>
    property Count: NativeInt read FLength;

    ///  <summary>Specifies the current capacity.</summary>
    ///  <returns>A positive number that specifies the number of elements that the queue can hold before it
    ///  needs to grow again.</returns>
    ///  <remarks>The value of this property is greater or equal to the amount of elements in the queue. If this value
    ///  if greater then the number of elements, it means that the queue has some extra capacity to operate upon.</remarks>
    property Capacity: NativeInt read GetCapacity;

    ///  <summary>Removes the excess capacity from the queue.</summary>
    ///  <remarks>This method can be called manually to force the queue to drop the extra capacity it might hold. For example,
    ///  after performing some massive operations of a big list, call this method to ensure that all extra memory held by the
    ///  queue is released.</remarks>
    procedure Shrink();

    ///  <summary>Forces the queue to increase its capacity.</summary>
    ///  <remarks>Call this method to force the queue to increase its capacity ahead of time. Manually adjusting the capacity
    ///  can be useful in certain situations.</remarks>
    procedure Grow();

    ///  <summary>Returns a new enumerator object used to enumerate this queue.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the queue.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<T>; override;

    ///  <summary>Copies the values stored in the queue to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the queue.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the queue.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of T; const AStartIndex: NativeInt); overload; override;

    ///  <summary>Checks whether the queue is empty.</summary>
    ///  <returns><c>True</c> if the queue is empty; <c>False</c> otherwise.</returns>
    ///  <remarks>This method is the recommended way of detecting if the queue is empty.</remarks>
    function Empty(): Boolean; override;

    ///  <summary>Returns the biggest element.</summary>
    ///  <returns>An element from the queue considered to have the biggest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Max(): T; override;

    ///  <summary>Returns the smallest element.</summary>
    ///  <returns>An element from the queue considered to have the smallest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Min(): T; override;

    ///  <summary>Returns the first element.</summary>
    ///  <returns>The first element in the queue.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function First(): T; override;

    ///  <summary>Returns the first element or a default if the queue is empty.</summary>
    ///  <param name="ADefault">The default value returned if the queue is empty.</param>
    ///  <returns>The first element in queue if the queue is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function FirstOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the last element.</summary>
    ///  <returns>The last element in the queue.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Last(): T; override;

    ///  <summary>Returns the last element or a default if the queue is empty.</summary>
    ///  <param name="ADefault">The default value returned if the queue is empty.</param>
    ///  <returns>The last element in queue if the queue is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function LastOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the single element stored in the queue.</summary>
    ///  <returns>The element in queue.</returns>
    ///  <remarks>This method checks if the queue contains just one element, in which case it is returned.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionNotOneException">There is more than one element in the queue.</exception>
    function Single(): T; override;

    ///  <summary>Returns the single element stored in the queue, or a default value.</summary>
    ///  <param name="ADefault">The default value returned if there is less or more elements in the queue.</param>
    ///  <returns>The element in the queue if the condition is satisfied; <paramref name="ADefault"/> is returned otherwise.</returns>
    ///  <remarks>This method checks if the queue contains just one element, in which case it is returned. Otherwise
    ///  the value in <paramref name="ADefault"/> is returned.</remarks>
    function SingleOrDefault(const ADefault: T): T; override;

    ///  <summary>Aggregates a value based on the queue's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <returns>A value that contains the queue's aggregated value.</returns>
    ///  <remarks>This method returns the first element if the queue only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Aggregate(const AAggregator: TFunc<T, T, T>): T; override;

    ///  <summary>Aggregates a value based on the queue's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <param name="ADefault">The default value returned if the queue is empty.</param>
    ///  <returns>A value that contains the queue's aggregated value. If the queue is empty, <paramref name="ADefault"/> is returned.</returns>
    ///  <remarks>This method returns the first element if the queue only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    function AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <returns>The element from the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    function ElementAt(const AIndex: NativeInt): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <param name="ADefault">The default value returned if the queue is empty.</param>
    ///  <returns>The element from the specified position if the queue is not empty and the position is not out of bounds; otherwise
    ///  the value of <paramref name="ADefault"/> is returned.</returns>
    function ElementAtOrDefault(const AIndex: NativeInt; const ADefault: T): T; override;

    ///  <summary>Check whether at least one element in the queue satisfies a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if the at least one element satisfies a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole queue and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>True</c>. The logical equivalent of this operation is "OR".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function Any(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks that all elements in the queue satisfy a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if all elements satisfy a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole queue and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>False</c>. The logical equivalent of this operation is "AND".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function All(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks whether the elements in this queue are equal to the elements in another collection.</summary>
    ///  <param name="ACollection">The collection to compare to.</param>
    ///  <returns><c>True</c> if the collections are equal; <c>False</c> if the collections are different.</returns>
    ///  <remarks>This methods checks that each element at position X in this queue is equal to an element at position X in
    ///  the provided collection. If the number of elements in both collections are different, then the collections are considered different.
    ///  Note that comparison of element is done using the type object used by this queue. This means that comparing this collection
    ///  to another one might yeild a different result than comparing the other collection to this one.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    function EqualsTo(const ACollection: IEnumerable<T>): Boolean; override;
  end;

  ///  <summary>The generic <c>queue (FIFO)</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses an internal array to store its objects.</remarks>
  TObjectQueue<T: class> = class(TQueue<T>)
  private
    FOwnsObjects: Boolean;

  protected
    //TODO: doc me.
    procedure HandleElementRemoved(const AElement: T); override;

  public
    ///  <summary>Specifies whether this queue owns the objects stored in it.</summary>
    ///  <returns><c>True</c> if the queue owns its objects; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the queue controls the life-time of the stored objects.</remarks>
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

type
  //TODO: use a derived type in order to receive removes notifications from the linked queue
  ///  <summary>The generic <c>queue (FIFO)</c> collection.</summary>
  ///  <remarks>This type uses a linked list to store its values.</remarks>
  TLinkedQueue<T> = class(TEnexCollection<T>, IQueue<T>)
  private var
    FList: TLinkedList<T>;

  protected
    ///  <summary>Returns the number of elements in the queue.</summary>
    ///  <returns>A positive value specifying the number of elements in the queue.</returns>
    function GetCount(): NativeInt; override;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(); overload;

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
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AArray: array of T); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the queue.</summary>
    ///  <remarks>This method clears the queue and invokes type object's cleaning routines for each element.</remarks>
    procedure Clear();

    ///  <summary>Appends an element to the top of the queue.</summary>
    ///  <param name="AValue">The value to append.</param>
    procedure Enqueue(const AValue: T);

    ///  <summary>Retreives the element from the bottom of the queue.</summary>
    ///  <returns>The value at the bottom of the queue.</returns>
    ///  <remarks>This method removes the element from the bottom of the queue.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Dequeue(): T;

    ///  <summary>Reads the element from the bottom of the queue.</summary>
    ///  <returns>The value at the bottom of the queue.</returns>
    ///  <remarks>This method does not remove the element from the bottom of the queue. It merely reads it's value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Peek(): T;

    ///  <summary>Checks whether the queue contains a given value.</summary>
    ///  <param name="AValue">The value to check.</param>
    ///  <returns><c>True</c> if the value was found in the queue; <c>False</c> otherwise.</returns>
    function Contains(const AValue: T): Boolean;

    ///  <summary>Specifies the number of elements in the queue.</summary>
    ///  <returns>A positive value specifying the number of elements in the queue.</returns>
    property Count: NativeInt read GetCount;

    ///  <summary>Returns a new enumerator object used to enumerate this queue.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the queue.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<T>; override;

    ///  <summary>Copies the values stored in the queue to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the queue.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the queue.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of T; const AStartIndex: NativeInt); overload; override;

    ///  <summary>Checks whether the queue is empty.</summary>
    ///  <returns><c>True</c> if the queue is empty; <c>False</c> otherwise.</returns>
    ///  <remarks>This method is the recommended way of detecting if the queue is empty.</remarks>
    function Empty(): Boolean; override;

    ///  <summary>Returns the biggest element.</summary>
    ///  <returns>An element from the queue considered to have the biggest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Max(): T; override;

    ///  <summary>Returns the smallest element.</summary>
    ///  <returns>An element from the queue considered to have the smallest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Min(): T; override;

    ///  <summary>Returns the first element.</summary>
    ///  <returns>The first element in the queue.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function First(): T; override;

    ///  <summary>Returns the first element or a default if the queue is empty.</summary>
    ///  <param name="ADefault">The default value returned if the queue is empty.</param>
    ///  <returns>The first element in queue if the queue is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function FirstOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the last element.</summary>
    ///  <returns>The last element in the queue.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Last(): T; override;

    ///  <summary>Returns the last element or a default if the queue is empty.</summary>
    ///  <param name="ADefault">The default value returned if the queue is empty.</param>
    ///  <returns>The last element in queue if the queue is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function LastOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the single element stored in the queue.</summary>
    ///  <returns>The element in queue.</returns>
    ///  <remarks>This method checks if the queue contains just one element, in which case it is returned.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionNotOneException">There is more than one element in the queue.</exception>
    function Single(): T; override;

    ///  <summary>Returns the single element stored in the queue, or a default value.</summary>
    ///  <param name="ADefault">The default value returned if there is less or more elements in the queue.</param>
    ///  <returns>The element in the queue if the condition is satisfied; <paramref name="ADefault"/> is returned otherwise.</returns>
    ///  <remarks>This method checks if the queue contains just one element, in which case it is returned. Otherwise
    ///  the value in <paramref name="ADefault"/> is returned.</remarks>
    function SingleOrDefault(const ADefault: T): T; override;

    ///  <summary>Aggregates a value based on the queue's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <returns>A value that contains the queue's aggregated value.</returns>
    ///  <remarks>This method returns the first element if the queue only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    function Aggregate(const AAggregator: TFunc<T, T, T>): T; override;

    ///  <summary>Aggregates a value based on the queue's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <param name="ADefault">The default value returned if the queue is empty.</param>
    ///  <returns>A value that contains the queue's aggregated value. If the queue is empty, <paramref name="ADefault"/> is returned.</returns>
    ///  <remarks>This method returns the first element if the queue only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    function AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <returns>The element from the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The queue is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    function ElementAt(const AIndex: NativeInt): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <param name="ADefault">The default value returned if the queue is empty.</param>
    ///  <returns>The element from the specified position if the queue is not empty and the position is not out of bounds; otherwise
    ///  the value of <paramref name="ADefault"/> is returned.</returns>
    function ElementAtOrDefault(const AIndex: NativeInt; const ADefault: T): T; override;

    ///  <summary>Check whether at least one element in the queue satisfies a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if the at least one element satisfies a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole queue and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>True</c>. The logical equivalent of this operation is "OR".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function Any(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks that all elements in the queue satisfy a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if all elements satisfy a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole queue and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>False</c>. The logical equivalent of this operation is "AND".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function All(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks whether the elements in this queue are equal to the elements in another collection.</summary>
    ///  <param name="ACollection">The collection to compare to.</param>
    ///  <returns><c>True</c> if the collections are equal; <c>False</c> if the collections are different.</returns>
    ///  <remarks>This methods checks that each element at position X in this queue is equal to an element at position X in
    ///  the provided collection. If the number of elements in both collections are different, then the collections are considered different.
    ///  Note that comparison of element is done using the type object used by this queue. This means that comparing this collection
    ///  to another one might yeild a different result than comparing the other collection to this one.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    function EqualsTo(const ACollection: IEnumerable<T>): Boolean; override;
  end;

  ///  <summary>The generic <c>queue (FIFO)</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses a linked list to store its objects.</remarks>
  TObjectLinkedQueue<T: class> = class(TLinkedQueue<T>)
  private
    FOwnsObjects: Boolean;

  protected
    //TODO: doc me.
    procedure HandleElementRemoved(const AElement: T); override;

  public
    ///  <summary>Specifies whether this queue owns the objects stored in it.</summary>
    ///  <returns><c>True</c> if the queue owns its objects; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the queue controls the life-time of the stored objects.</remarks>
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

type
  { Priority Queue }
  //TODO: doc me
  TPriorityQueue<TPriority, TValue> = class(TEnexAssociativeCollection<TPriority, TValue>, IPriorityQueue<TPriority, TValue>, IDynamic)
  private type
    {$REGION 'Internal Types'}
    { Internal storage }
    TPriorityPair = record
      FPriority: TPriority;
      FValue: TValue;
    end;

    { Generic List Enumerator }
    TPairEnumerator = class(TEnumerator<TPair<TPriority, TValue>>)
    private
      FVer: NativeInt;
      FQueue: TPriorityQueue<TPriority, TValue>;
      FCurrentIndex: NativeInt;

    public
      { Constructor }
      constructor Create(const AQueue: TPriorityQueue<TPriority, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TPair<TPriority, TValue>; override;
      function MoveNext(): Boolean; override;
    end;
    {$ENDREGION}

  private
    FCount: NativeInt;
    FVer: NativeInt;
    FSign: NativeInt;
    FArray: TArray<TPriorityPair>;

    { Used internally to remove items from queue }
    function RemoveAt(const AIndex: NativeInt): TPriorityPair;

  protected
    { Serialization overrides }
    { ICollection support/hidden }
    //TODO: doc me
    function GetCount(): NativeInt; override;

    { Gets the current capacity of the collection }
    //TODO: doc me
    function GetCapacity(): NativeInt;
  public
    { Constructors }
    //TODO: doc me
    constructor Create(const Ascending: Boolean = true); overload;
    //TODO: doc me
    constructor Create(const AInitialCapacity: NativeInt; const Ascending: Boolean = true); overload;
    //TODO: doc me
    constructor Create(const AEnumerable: IEnumerable<TPair<TPriority, TValue>>; const Ascending: Boolean = true); overload;
    //TODO: doc me
    constructor Create(const AArray: array of TPair<TPriority, TValue>; const Ascending: Boolean = true); overload;

    constructor Create(const APriorityType: TRules<TPriority>; const AValueRules: TRules<TValue>;
      const Ascending: Boolean = true); overload;
      //TODO: doc me
    constructor Create(const APriorityType: TRules<TPriority>; const AValueRules: TRules<TValue>;
      const AInitialCapacity: NativeInt; const Ascending: Boolean = true); overload;
      //TODO: doc me
    constructor Create(const APriorityType: TRules<TPriority>; const AValueRules: TRules<TValue>;
      const AEnumerable: IEnumerable<TPair<TPriority, TValue>>; const Ascending: Boolean = true); overload;
      //TODO: doc me
    constructor Create(const APriorityType: TRules<TPriority>; const AValueRules: TRules<TValue>;
      const AArray: array of TPair<TPriority, TValue>; const Ascending: Boolean = true); overload;

    { Destructor }
    //TODO: doc me
    destructor Destroy(); override;

    { IPriorityQueue }
    //TODO: doc me
    procedure Clear();
    //TODO: doc me
    function Contains(const AValue: TValue): Boolean;

    //TODO: doc me
    procedure Enqueue(const AValue: TValue); overload;
    //TODO: doc me
    procedure Enqueue(const AValue: TValue; const APriority: TPriority); overload;
    //TODO: doc me
    function Dequeue(): TValue; overload;
    //TODO: doc me
    function Peek(): TValue; overload;

    { Properties }
    //TODO: doc me
    property Count: NativeInt read FCount;
    //TODO: doc me
    property Capacity: NativeInt read GetCapacity;

    { IEnumerable/ ICollection support }
    //TODO: doc me
    function GetEnumerator() : IEnumerator<TPair<TPriority, TValue>>; override;

    { Grow/Shrink }
    //TODO: doc me
    procedure Shrink();
    //TODO: doc me
    procedure Grow();

    { Enex: Copy-To }
    //TODO: doc me
    procedure CopyTo(var AArray: array of TPair<TPriority, TValue>; const AStartIndex: NativeInt); overload; override;

    { Enex - Associative collection }
    //TODO: doc me
    function MaxKey(): TPriority; override;
  end;

  { The object variant }
  //TODO: doc me
  TObjectPriorityQueue<TPriority, TValue> = class(TPriorityQueue<TPriority, TValue>)
  private
    FOwnsPriorities, FOwnsValues: Boolean;

  protected
    //TODO: doc me.
    procedure HandleKeyRemoved(const AKey: TPriority); override;
    //TODO: doc me.
    procedure HandleValueRemoved(const AValue: TValue); override;
  public
    { Object owning }
    //TODO: doc me
    property OwnsPriorities: Boolean read FOwnsPriorities write FOwnsPriorities;
    //TODO: doc me
    property OwnsValues: Boolean read FOwnsValues write FOwnsValues;
  end;

implementation

{ TQueue<T> }

function TQueue<T>.Aggregate(const AAggregator: TFunc<T, T, T>): T;
var
  I, H: NativeInt;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Select the first element as comparison base }
  Result := FArray[FHead];

  H := (FHead + 1) mod Length(FArray);

  for I := 1 to FLength - 1 do
  begin
    { Aggregate a value }
    Result := AAggregator(Result, FArray[H]);

    { Circulate Head }
    H := (H + 1) mod Length(FArray);
  end;
end;

function TQueue<T>.AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T;
var
  I, H: NativeInt;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  if FLength = 0 then
    Exit(ADefault);

  { Select the first element as comparison base }
  Result := FArray[FHead];

  H := (FHead + 1) mod Length(FArray);

  for I := 1 to FLength - 1 do
  begin
    { Aggregate a value }
    Result := AAggregator(Result, FArray[H]);

    { Circulate Head }
    H := (H + 1) mod Length(FArray);
  end;
end;

function TQueue<T>.All(const APredicate: TFunc<T, Boolean>): Boolean;
var
  I, H: NativeInt;
begin
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  if FLength > 0 then
  begin
    H := FHead;
    for I := 0 to FLength - 1 do
    begin
      if not APredicate(FArray[H]) then
        Exit(false);

      { Circulate Head }
      H := (H + 1) mod Length(FArray);
    end;
  end;

  Result := true;
end;

function TQueue<T>.Any(const APredicate: TFunc<T, Boolean>): Boolean;
var
  I, H: NativeInt;
begin
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  if FLength > 0 then
  begin
    H := FHead;
    for I := 0 to FLength - 1 do
    begin
      if APredicate(FArray[H]) then
        Exit(true);

      { Circulate Head }
      H := (H + 1) mod Length(FArray);
    end;
  end;

  Result := false;
end;

procedure TQueue<T>.Clear;
var
  Element: T;
begin
  { If must cleanup, use the dequeue method }
  while Count > 0 do
  begin
    Element := Dequeue();
    HandleElementRemoved(Element);
  end;

  { Clear all internals }
  FTail := 0;
  FHead := 0;
  FLength := 0;

  Inc(FVer);
end;

function TQueue<T>.Contains(const AValue: T): Boolean;
var
  I: NativeInt;
  Capacity: NativeInt;
begin
  { Do a look-up in all the queue }
  Result := False;

  I := FHead;
  Capacity := Length(FArray);

  while I <> FTail do
  begin
    if ElementRules.AreEqual(FArray[I], AValue) then
    begin
      Result := True;
      Break;
    end;

    { Next + wrap over }
    I := (I + 1) mod Capacity;
  end;

end;
                 
procedure TQueue<T>.CopyTo(var AArray: array of T; const AStartIndex: NativeInt);
var
  I, X: NativeInt;
  Capacity: NativeInt;
begin
  { Check for indexes }
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (Length(AArray) - AStartIndex) < Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;
  I := FHead;
  Capacity := Length(FArray);

  while FTail <> I do
  begin
    { Copy value }
    AArray[X] := FArray[I];

    { Next + wrap over }
    I := (I + 1) mod Capacity;
    Inc(X);
  end;
end;

constructor TQueue<T>.Create(const ARules: TRules<T>;
  const ACollection: IEnumerable<T>);
var
  V: T;
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);

  { Initialize instance }
  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Try to copy the given Enumerable }
  for V in ACollection do
  begin
    { Perform a simple push }
    Enqueue(V);
  end;
end;

constructor TQueue<T>.Create;
begin
  Create(TRules<T>.Default);
end;

constructor TQueue<T>.Create(const AInitialCapacity: NativeInt);
begin
  Create(TRules<T>.Default, AInitialCapacity);
end;

constructor TQueue<T>.Create(const ACollection: IEnumerable<T>);
begin
  Create(TRules<T>.Default, ACollection);
end;

constructor TQueue<T>.Create(const ARules: TRules<T>;
  const AInitialCapacity: NativeInt);
begin
  inherited Create(ARules);

  FVer := 0;
  FTail := 0;
  FLength := 0;
  FHead := 0;
  SetLength(FArray, AInitialCapacity);
end;

constructor TQueue<T>.Create(const ARules: TRules<T>);
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);
end;

function TQueue<T>.ElementAt(const AIndex: NativeInt): T;
var
  H: NativeInt;
begin
  if (AIndex >= FLength) or (AIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  H := (FHead + AIndex) mod Length(FArray);
  Result := FArray[H];
end;

function TQueue<T>.ElementAtOrDefault(const AIndex: NativeInt; const ADefault: T): T;
var
  H: NativeInt;
begin
  if (AIndex >= FLength) or (AIndex < 0) then
    Exit(ADefault);

  H := (FHead + AIndex) mod Length(FArray);
  Result := FArray[H];
end;

function TQueue<T>.Empty: Boolean;
begin
  Result := (FLength = 0);
end;

procedure TQueue<T>.Enqueue(const AValue: T);
var
  NewCapacity: NativeInt;
begin
  { Ensure Capacity }
  if FLength = Length(FArray) then
  begin
    NewCapacity := Length(FArray) * 2;

    if NewCapacity < CDefaultSize then
       NewCapacity := Length(FArray) + CDefaultSize;

    SetCapacity(NewCapacity);
  end;

  { Place the element to the end of the list }
  FArray[FTail] := AValue;  
  FTail := (FTail + 1) mod Length(FArray);
  
  Inc(FLength);
  Inc(FVer);
end;

function TQueue<T>.EqualsTo(const ACollection: IEnumerable<T>): Boolean;
var
  V: T;
  I, H: NativeInt;
begin
  I := 0;
  H := FHead;

  for V in ACollection do
  begin
    if I >= FLength then
      Exit(false);

    if not ElementRules.AreEqual(FArray[H], V) then
      Exit(false);

    H := (H + 1) mod Length(FArray);
    Inc(I);
  end;

  if I < FLength then
    Exit(false);

  Result := true;
end;

function TQueue<T>.First: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[FHead];
end;

function TQueue<T>.FirstOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else
    Result := FArray[FHead];
end;

destructor TQueue<T>.Destroy;
begin
  { Cleanup }
  Clear();

  inherited;
end;

function TQueue<T>.Dequeue: T;
begin
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Get the head }
  Result := FArray[FHead];

  { Circulate Head }
  FHead := (FHead + 1) mod Length(FArray);

  Dec(FLength);
  Inc(FVer);
end;

function TQueue<T>.GetCapacity: NativeInt;
begin
  Result := Length(FArray);
end;

function TQueue<T>.GetCount: NativeInt;
begin
  Result := FLength;
end;

function TQueue<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Self);
end;

procedure TQueue<T>.Grow;
var
  NewCapacity: NativeInt;
begin
  { Ensure Capacity }
  if FLength = Length(FArray) then
  begin
    NewCapacity := Length(FArray) * 2;

    if NewCapacity < CDefaultSize then
       NewCapacity := Length(FArray) + CDefaultSize;

    SetCapacity(NewCapacity);
  end;
end;

function TQueue<T>.Last: T;
var
  T: NativeInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  T := (FTail - 1) mod Length(FArray);
  Result := FArray[T];
end;

function TQueue<T>.LastOrDefault(const ADefault: T): T;
var
  T: NativeInt;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else
  begin
    T := (FTail - 1) mod Length(FArray);
    Result := FArray[T];
  end;
end;

function TQueue<T>.Max: T;
var
  I, H: NativeInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  H := FHead;
  Result := FArray[H];

  H := (H + 1) mod Length(FArray);

  for I := 1 to FLength - 1 do
  begin
    if ElementRules.Compare(FArray[H], Result) > 0 then
      Result := FArray[I];

    { Circulate Head }
    H := (H + 1) mod Length(FArray);
  end;
end;

function TQueue<T>.Min: T;
var
  I, H: NativeInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  H := FHead;
  Result := FArray[H];

  H := (H + 1) mod Length(FArray);

  for I := 1 to FLength - 1 do
  begin
    if ElementRules.Compare(FArray[H], Result) < 0 then
      Result := FArray[I];

    { Circulate Head }
    H := (H + 1) mod Length(FArray);
  end;
end;

function TQueue<T>.Peek: T;
begin
  if FTail = FHead then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[FHead];
end;

procedure TQueue<T>.SetCapacity(const ANewCapacity: NativeInt);
var
 NewArray: TArray<T>;
begin
  { Create new array }
  SetLength(NewArray, ANewCapacity);

  if (FLength > 0) then
  begin
    if FHead < FTail then
       Move(FArray[FHead], NewArray[0], FLength * SizeOf(T))
    else
    begin
       Move(FArray[FHead], NewArray[0], (FLength - FHead) * SizeOf(T));
       Move(FArray[0], NewArray[Length(FArray) - FHead], FTail * SizeOf(T));
    end;
  end;

  { Switch arrays }
  FArray := nil;
  FArray := NewArray;
  
  FTail := FLength;
  FHead := 0;
  Inc(FVer);
end;

procedure TQueue<T>.Shrink;
begin
  { Ensure Capacity }
  if FLength < Capacity then
  begin
    SetCapacity(FLength);
  end;
end;

function TQueue<T>.Single: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError()
  else if FLength > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FArray[FHead];
end;

function TQueue<T>.SingleOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else if FLength > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FArray[FHead];
end;

constructor TQueue<T>.Create(const AArray: array of T);
begin
  Create(TRules<T>.Default, AArray);
end;

constructor TQueue<T>.Create(const ARules: TRules<T>; const AArray: array of T);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);

  { Copy array }
  for I := 0 to Length(AArray) - 1 do
  begin
    Enqueue(AArray[I]);
  end;
end;

{ TQueue<T>.TEnumerator }

constructor TQueue<T>.TEnumerator.Create(const AQueue: TQueue<T>);
begin
  { Initialize }
  FQueue := AQueue;
  KeepObjectAlive(FQueue);

  FCount := 0;
  FElement := Default(T);
  FHead  := FQueue.FHead;
  FVer := AQueue.FVer;
end;

destructor TQueue<T>.TEnumerator.Destroy;
begin
  ReleaseObject(FQueue);
  inherited;
end;

function TQueue<T>.TEnumerator.GetCurrent: T;
begin
  if FVer <> FQueue.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FElement;
end;

function TQueue<T>.TEnumerator.MoveNext: Boolean;
begin
  if FVer <> FQueue.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  if (FCount >= FQueue.FLength) then
    Exit(false)
  else
    Result := true;

  FElement := FQueue.FArray[FHead];

  { Circulate Head }
  FHead := (FHead + 1) mod Length(FQueue.FArray);
  Inc(FCount);
end;

{ TObjectQueue<T> }

procedure TObjectQueue<T>.HandleElementRemoved(const AElement: T);
begin
  TObject(AElement).Free;
end;

{ TLinkedQueue<T> }

function TLinkedQueue<T>.Aggregate(const AAggregator: TFunc<T, T, T>): T;
begin
  { Call the one from the list }
  Result := FList.Aggregate(AAggregator);
end;

function TLinkedQueue<T>.AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T;
begin
  { Call the one from the list }
  Result := FList.AggregateOrDefault(AAggregator, ADefault);
end;

function TLinkedQueue<T>.All(const APredicate: TFunc<T, Boolean>): Boolean;
begin
  { Call the one from the list }
  Result := FList.All(APredicate);
end;

function TLinkedQueue<T>.Any(const APredicate: TFunc<T, Boolean>): Boolean;
begin
  { Call the one from the list }
  Result := FList.Any(APredicate);
end;

procedure TLinkedQueue<T>.Clear;
begin
  { Clear the internal list }
  if FList <> nil then
    FList.Clear();
end;

function TLinkedQueue<T>.Contains(const AValue: T): Boolean;
begin
  { Use the list }
  Result := FList.Contains(AValue);
end;

procedure TLinkedQueue<T>.CopyTo(var AArray: array of T; const AStartIndex: NativeInt);
begin
  { Invoke the copy-to from the list below }
  FList.CopyTo(AArray, AStartIndex);
end;

constructor TLinkedQueue<T>.Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>);
var
  V: T;
begin
  { Call upper constructor }
  Create(ARules);

  { Initialize instance }
  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AEnumerable');

  { Try to copy the given Enumerable }
  for V in ACollection do
    Enqueue(V);
end;

constructor TLinkedQueue<T>.Create;
begin
  Create(TRules<T>.Default);
end;

constructor TLinkedQueue<T>.Create(const ACollection: IEnumerable<T>);
begin
  Create(TRules<T>.Default, ACollection);
end;

constructor TLinkedQueue<T>.Create(const ARules: TRules<T>);
begin
  { Initialize internals }
  inherited Create(ARules);

  FList := TLinkedList<T>.Create(ElementRules);
end;

function TLinkedQueue<T>.ElementAt(const AIndex: NativeInt): T;
begin
  { Call the one from the list }
  Result := FList.ElementAt(AIndex);
end;

function TLinkedQueue<T>.ElementAtOrDefault(const AIndex: NativeInt; const ADefault: T): T;
begin
  { Call the one from the list }
  Result := FList.ElementAtOrDefault(AIndex, ADefault);
end;

function TLinkedQueue<T>.Empty: Boolean;
begin
  { Call the one from the list }
  Result := FList.Empty;
end;

procedure TLinkedQueue<T>.Enqueue(const AValue: T);
begin
  { Add a new node to the linked list }
  FList.AddLast(AValue);
end;

function TLinkedQueue<T>.EqualsTo(const ACollection: IEnumerable<T>): Boolean;
begin
  { Call the one from the list }
  Result := FList.EqualsTo(ACollection);
end;

function TLinkedQueue<T>.First: T;
begin
  { Call the one from the list }
  Result := FList.First;
end;

function TLinkedQueue<T>.FirstOrDefault(const ADefault: T): T;
begin
  { Call the one from the list }
  Result := FList.FirstOrDefault(ADefault);
end;

destructor TLinkedQueue<T>.Destroy;
begin
  { Cleanup }
  Clear();

  inherited;
end;

function TLinkedQueue<T>.Dequeue: T;
begin
  { Call the list ... again! }
  Result := FList.RemoveAndReturnFirst();
end;

function TLinkedQueue<T>.GetCount: NativeInt;
begin
  Result := FList.Count;
end;

function TLinkedQueue<T>.GetEnumerator: IEnumerator<T>;
begin
  { Get the list enumerator }
  Result := FList.GetEnumerator();
end;

function TLinkedQueue<T>.Last: T;
begin
  { Call the one from the list }
  Result := FList.Last;
end;

function TLinkedQueue<T>.LastOrDefault(const ADefault: T): T;
begin
  { Call the one from the list }
  Result := FList.LastOrDefault(ADefault);
end;

function TLinkedQueue<T>.Max: T;
begin
  { Call the one from the list }
  Result := FList.Max;
end;

function TLinkedQueue<T>.Min: T;
begin
  { Call the one from the list }
  Result := FList.Min;
end;

function TLinkedQueue<T>.Peek: T;
begin
  if FList.FirstNode = nil then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FList.FirstNode.Value;
end;

function TLinkedQueue<T>.Single: T;
begin
  { Call the one from the list }
  Result := FList.Single;
end;

function TLinkedQueue<T>.SingleOrDefault(const ADefault: T): T;
begin
  { Call the one from the list }
  Result := FList.SingleOrDefault(ADefault);
end;

constructor TLinkedQueue<T>.Create(const AArray: array of T);
begin
  Create(TRules<T>.Default, AArray);
end;

constructor TLinkedQueue<T>.Create(const ARules: TRules<T>; const AArray: array of T);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(ARules);

  { Copy array }
  for I := 0 to Length(AArray) - 1 do
  begin
    Enqueue(AArray[I]);
  end;
end;

{ TObjectLinkedQueue<T> }

procedure TObjectLinkedQueue<T>.HandleElementRemoved(const AElement: T);
begin
  TObject(AElement).Free;
end;

{ TPriorityQueue<TPriority, TValue> }

procedure TPriorityQueue<TPriority, TValue>.Clear;
var
  I: NativeInt;
begin
  { Cleanup the array }
  for I := 0 to Length(FArray) - 1 do
  begin
    HandleKeyRemoved(FArray[I].FPriority);
    HandleValueRemoved(FArray[I].FValue);
  end;

  { Dispose of all the stuff }
  Inc(FVer);
  FCount := 0;
end;

function TPriorityQueue<TPriority, TValue>.Contains(const AValue: TValue): Boolean;
var
  I: NativeInt;
begin
  { Check whether the thing contains what we need }
  if FCount > 0 then
    for I := 0 to FCount - 1 do
      if ValueRules.AreEqual(FArray[I].FValue, AValue) then
        Exit(true);

  { Nope ... }
  Result := false;
end;

procedure TPriorityQueue<TPriority, TValue>.CopyTo(var AArray: array of TPair<TPriority, TValue>; const AStartIndex: NativeInt);
var
  I: NativeInt;
begin
  { Check for indexes }
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (Length(AArray) - AStartIndex) < FCount then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  { Copy the stuff in }
  for I := 0 to FCount - 1 do
  begin
    AArray[AStartIndex + I].Key := FArray[I].FPriority;
    AArray[AStartIndex + I].Value := FArray[I].FValue;
  end;
end;

constructor TPriorityQueue<TPriority, TValue>.Create(const AArray: array of TPair<TPriority, TValue>;
  const Ascending: Boolean);
begin
  { Call upper constructor }
  Create(TRules<TPriority>.Default, TRules<TValue>.Default, AArray, Ascending);
end;

constructor TPriorityQueue<TPriority, TValue>.Create(const AEnumerable: IEnumerable<TPair<TPriority, TValue>>;
  const Ascending: Boolean);
begin
  { Call upper constructor }
  Create(TRules<TPriority>.Default, TRules<TValue>.Default, AEnumerable, Ascending);
end;

constructor TPriorityQueue<TPriority, TValue>.Create(const Ascending: Boolean);
begin
  { Call upper constructor }
  Create(TRules<TPriority>.Default, TRules<TValue>.Default, CDefaultSize, Ascending);
end;

constructor TPriorityQueue<TPriority, TValue>.Create(
  const APriorityType: TRules<TPriority>;
  const AValueRules: TRules<TValue>;
  const AArray: array of TPair<TPriority, TValue>;
  const Ascending: Boolean);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(APriorityType, AValueRules, CDefaultSize, Ascending);

  { Copy all items in }
  if Length(AArray) > 0 then
    for I := 0 to Length(AArray) - 1 do
      Enqueue(AArray[I].Value, AArray[I].Key);
end;

constructor TPriorityQueue<TPriority, TValue>.Create(
  const APriorityType: TRules<TPriority>;
  const AValueRules: TRules<TValue>;
  const AInitialCapacity: NativeInt;
  const Ascending: Boolean);
begin
  { Install types }
  inherited Create(APriorityType, AValueRules);

  SetLength(FArray, AInitialCapacity);
  FVer := 0;
  FCount := 0;

  if Ascending then
    FSign := 1
  else
    FSign := -1;
end;

constructor TPriorityQueue<TPriority, TValue>.Create(const AInitialCapacity: NativeInt; const Ascending: Boolean);
begin
  { Call upper constructor }
  Create(TRules<TPriority>.Default, TRules<TValue>.Default, AInitialCapacity, Ascending);
end;

constructor TPriorityQueue<TPriority, TValue>.Create(
  const APriorityType: TRules<TPriority>;
  const AValueRules: TRules<TValue>;
  const AEnumerable: IEnumerable<TPair<TPriority, TValue>>;
  const Ascending: Boolean);
var
  V: TPair<TPriority, TValue>;
begin
  { Call upper constructor }
  Create(APriorityType, AValueRules, CDefaultSize, Ascending);

  if (AEnumerable = nil) then
     ExceptionHelper.Throw_ArgumentNilError('AEnumerable');

  { Pump in all items }
  for V in AEnumerable do
    Enqueue(V.Value, V.Key);
end;

constructor TPriorityQueue<TPriority, TValue>.Create(
  const APriorityType: TRules<TPriority>;
  const AValueRules: TRules<TValue>;
  const Ascending: Boolean);
begin
  { Call upper constructor }
  Create(APriorityType, AValueRules, CDefaultSize, Ascending);
end;

function TPriorityQueue<TPriority, TValue>.Dequeue: TValue;
var
  LPair: TPriorityPair;
begin
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Extract element at position zero (the head) }
  LPair := RemoveAt(0);

  { CLeanup the priority element }
  HandleKeyRemoved(LPair.FPriority);

  { And return the value }
  Result := LPair.FValue;
  Inc(FVer);
end;

destructor TPriorityQueue<TPriority, TValue>.Destroy;
begin
  { First clear }
  Clear();

  inherited;
end;

procedure TPriorityQueue<TPriority, TValue>.Enqueue(const AValue: TValue; const APriority: TPriority);
var
  I, X: NativeInt;
begin
  { Grow if required }
  if FCount = Length(FArray) then
    Grow();

  I := FCount;
  Inc(FCount);

  { Move items to new positions }
  while true do
  begin
    if I > 0 then
      X := (I - 1) div 2
    else
      X := 0;

    { Check for exit }
    if (I = 0) or ((KeyRules.Compare(FArray[X].FPriority, APriority) * FSign) > 0) then
      break;

    FArray[I] := FArray[X];
    I := X;
  end;

  { Insert the new item }
  FArray[I].FPriority := APriority;
  FArray[I].FValue := AValue;

  Inc(FVer);
end;

procedure TPriorityQueue<TPriority, TValue>.Enqueue(const AValue: TValue);
begin
  { Insert with default priority }
  Enqueue(AValue, default(TPriority));
end;

function TPriorityQueue<TPriority, TValue>.GetCapacity: NativeInt;
begin
  Result := Length(FArray);
end;

function TPriorityQueue<TPriority, TValue>.GetCount: NativeInt;
begin
  { Use the FCount }
  Result := FCount;
end;

function TPriorityQueue<TPriority, TValue>.GetEnumerator: IEnumerator<TPair<TPriority, TValue>>;
begin
  { Create an enumerator }
  Result := TPairEnumerator.Create(Self);
end;

procedure TPriorityQueue<TPriority, TValue>.Grow;
var
  LNewCapacity: NativeInt;
begin
  LNewCapacity := Length(FArray) * 2;

  if LNewCapacity < CDefaultSize then
    LNewCapacity := CDefaultSize;

  { Extend the array }
  SetLength(FArray, LNewCapacity);
end;

function TPriorityQueue<TPriority, TValue>.MaxKey: TPriority;
begin
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[0].FPriority;
end;

function TPriorityQueue<TPriority, TValue>.Peek: TValue;
begin
  if FCount = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Peek at the element at position zero (the head) }
  Result := FArray[0].FValue;
end;

function TPriorityQueue<TPriority, TValue>.RemoveAt(const AIndex: NativeInt): TPriorityPair;
var
  LTemp: TPriorityPair;
  I, X, LStart: NativeInt;
begin
  { Obtain the item that is removed }
  Result := FArray[AIndex];
  LTemp := FArray[FCount - 1];

  Dec(FCount);

  { Fill in the create hole }
  if (FCount = 0) or (AIndex = FCount) then
    Exit;

  I := AIndex;

  if I > 0 then
    LStart := (I - 1) div 2
  else
    LStart := 0;

  while ((KeyRules.Compare(LTemp.FPriority, FArray[LStart].FPriority) * FSign) > 0) do
  begin
    FArray[I] := FArray[LStart];
    I := LStart;

    if I > 0 then
      LStart := (I - 1) div 2
    else
      LStart := 0;
  end;

  if (I = AIndex) then
  begin
    while (I < (FCount div 2)) do
    begin
      X := (I * 2) + 1;

      if ((X < FCount - 1) and ((KeyRules.Compare(FArray[X].FPriority, FArray[X + 1].FPriority) * FSign) < 0)) then
        Inc(X);

      if ((KeyRules.Compare(FArray[X].FPriority, LTemp.FPriority) * FSign) <= 0) then
          break;

      FArray[I] := FArray[X];
      I := X;
    end;
  end;

  FArray[I] := LTemp;
end;

procedure TPriorityQueue<TPriority, TValue>.Shrink;
begin
  { Remove the excess stuff }
  if FCount < Length(FArray) then
    SetLength(FArray, FCount);
end;

{ TPriorityQueue<TPriority, TValue>.TPairEnumerator }

constructor TPriorityQueue<TPriority, TValue>.TPairEnumerator.Create(const AQueue: TPriorityQueue<TPriority, TValue>);
begin
  FQueue := AQueue;
  KeepObjectAlive(FQueue);

  FVer := AQueue.FVer;
  FCurrentIndex := 0;
end;

destructor TPriorityQueue<TPriority, TValue>.TPairEnumerator.Destroy;
begin
  ReleaseObject(FQueue);
  inherited;
end;

function TPriorityQueue<TPriority, TValue>.TPairEnumerator.GetCurrent: TPair<TPriority, TValue>;
begin
  if FVer <> FQueue.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  if FCurrentIndex > 0 then
  begin
    Result.Key := FQueue.FArray[FCurrentIndex - 1].FPriority;
    Result.Value := FQueue.FArray[FCurrentIndex - 1].FValue;
  end else
    Result := default(TPair<TPriority, TValue>);
end;

function TPriorityQueue<TPriority, TValue>.TPairEnumerator.MoveNext: Boolean;
begin
  if FVer <> FQueue.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FCurrentIndex < FQueue.FCount;
  Inc(FCurrentIndex);
end;

{ TObjectPriorityQueue<TPriority, TValue> }

procedure TObjectPriorityQueue<TPriority, TValue>.HandleKeyRemoved(const AKey: TPriority);
begin
  TObject(AKey).Free;
end;

procedure TObjectPriorityQueue<TPriority, TValue>.HandleValueRemoved(const AValue: TValue);
begin
  TObject(AValue).Free;
end;

end.
