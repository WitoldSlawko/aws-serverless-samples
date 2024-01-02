There’s an important distinction that is missing from the other answers:

    * Query requires a partition key
    * BatchGetItems requires a primary key

`Query` is only useful if the items you want to get happen to share a partition (hash) key, and you must provide this value. Furthermore, you have to provide the exact value; you can’t do any partial matching against the partition key. From there you can specify an additional (and potentially partial/conditional) value for the sort key to reduce the amount of data read, and further reduce the output with a FilterExpression. This is great, but it has the big limitation that you can’t get data that lives outside a single partition.

`BatchGetItems` is the flip side of this. You can get data across many partitions (and even across multiple tables), but you have to know the full and exact primary key: that is, both the partition (hash) key and any sort (range). It’s literally like calling GetItem multiple times in a single operation. You don’t have the partial-searching and filtering options of Query, but you’re not limited to a single partition either.
