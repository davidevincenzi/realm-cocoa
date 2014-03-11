//
//  query.m
//  TightDB
//

#import <SenTestingKit/SenTestingKit.h>

#import <tightdb/objc/tightdb.h>

TIGHTDB_TABLE_1(TestQuerySub,
                Age,  Int)

TIGHTDB_TABLE_9(TestQueryAllTypes,
                BoolCol,   Bool,
                IntCol,    Int,
                FloatCol,  Float,
                DoubleCol, Double,
                StringCol, String,
                BinaryCol, Binary,
                DateCol,   Date,
                TableCol,  TestQuerySub,
                MixedCol,  Mixed)

@interface MACtestQuery: SenTestCase
@end
@implementation MACtestQuery

- (void)testQuery
{
    TestQueryAllTypes *table = [[TestQueryAllTypes alloc] init];
    NSLog(@"Table: %@", table);
    STAssertNotNil(table, @"Table is nil");

    const char bin[4] = { 0, 1, 2, 3 };
    TightdbBinary *bin1 = [[TightdbBinary alloc] initWithData:bin size:sizeof bin / 2];
    TightdbBinary *bin2 = [[TightdbBinary alloc] initWithData:bin size:sizeof bin];
    time_t timeNow = [[NSDate date] timeIntervalSince1970];
//    TestQuerySub *subtab1 = [[TestQuerySub alloc] init];
    TestQuerySub *subtab2 = [[TestQuerySub alloc] init];
    [subtab2 addAge:100];
    TightdbMixed *mixInt1   = [TightdbMixed mixedWithInt64:1];
    TightdbMixed *mixSubtab = [TightdbMixed mixedWithTable:subtab2];

    [table addBoolCol:NO   IntCol:54       FloatCol:0.7     DoubleCol:0.8       StringCol:@"foo"
            BinaryCol:bin1 DateCol:0       TableCol:nil     MixedCol:mixInt1];

    [table addBoolCol:YES  IntCol:506      FloatCol:7.7     DoubleCol:8.8       StringCol:@"banach"
            BinaryCol:bin2 DateCol:timeNow TableCol:subtab2 MixedCol:mixSubtab];

    STAssertEquals([[[table where].BoolCol   columnIsEqualTo:NO]      count], (NSUInteger)1, @"BoolCol equal");
    STAssertEquals([[[table where].IntCol    columnIsEqualTo:54]      count], (NSUInteger)1, @"IntCol equal");
    STAssertEquals([[[table where].FloatCol  columnIsEqualTo:0.7f]    count], (NSUInteger)1, @"FloatCol equal");
    STAssertEquals([[[table where].DoubleCol columnIsEqualTo:0.8]     count], (NSUInteger)1, @"DoubleCol equal");
    STAssertEquals([[[table where].StringCol columnIsEqualTo:@"foo"]  count], (NSUInteger)1, @"StringCol equal");
    STAssertEquals([[[table where].BinaryCol columnIsEqualTo:bin1]    count], (NSUInteger)1, @"BinaryCol equal");
    STAssertEquals([[[table where].DateCol   columnIsEqualTo:0]       count], (NSUInteger)1, @"DateCol equal");
// These are not yet implemented
//    STAssertEquals([[[table where].TableCol  columnIsEqualTo:subtab1] count], (size_t)1, @"TableCol equal");
//    STAssertEquals([[[table where].MixedCol  columnIsEqualTo:mixInt1] count], (size_t)1, @"MixedCol equal");

    TestQueryAllTypes_Query *query = [[table where].BoolCol   columnIsEqualTo:NO];

    STAssertEquals([[query.IntCol minimum] longLongValue], (int64_t)54,    @"IntCol min");
    STAssertEquals([[query.IntCol maximum] longLongValue], (int64_t)54,    @"IntCol max");
    STAssertEquals([[query.IntCol sum] longLongValue], (int64_t)54,    @"IntCol sum");
    STAssertEquals([[query.IntCol average] doubleValue], 54.0,           @"IntCol avg");

    STAssertEquals([[query.FloatCol minimum] floatValue], 0.7f,         @"FloatCol min");
    STAssertEquals([[query.FloatCol maximum] floatValue], 0.7f,         @"FloatCol max");
    STAssertEquals([[query.FloatCol sum] floatValue], 0.7f, @"FloatCol sum");
    STAssertEquals([[query.FloatCol average] doubleValue], (double)0.7f, @"FloatCol avg");

    STAssertEquals([[query.DoubleCol minimum] doubleValue], 0.8,         @"DoubleCol min");
    STAssertEquals([[query.DoubleCol maximum] doubleValue], 0.8,         @"DoubleCol max");
    STAssertEquals([[query.DoubleCol sum] doubleValue], 0.8,         @"DoubleCol sum");
    STAssertEquals([[query.DoubleCol average] doubleValue], 0.8,         @"DoubleCol avg");

    // Check that all column conditions return query objects of the
    // right type
    [[[table where].BoolCol columnIsEqualTo:NO].BoolCol columnIsEqualTo:NO];

    [[[table where].IntCol columnIsEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].IntCol columnIsNotEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].IntCol columnIsLessThan:0].BoolCol columnIsEqualTo:NO];
    [[[table where].IntCol columnIsLessThanOrEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].IntCol columnIsGreaterThan:0].BoolCol columnIsEqualTo:NO];
    [[[table where].IntCol columnIsGreaterThanOrEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].IntCol columnIsBetween:0 and_:0].BoolCol columnIsEqualTo:NO];

    [[[table where].FloatCol columnIsEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].FloatCol columnIsNotEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].FloatCol columnIsLessThan:0].BoolCol columnIsEqualTo:NO];
    [[[table where].FloatCol columnIsLessThanOrEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].FloatCol columnIsGreaterThan:0].BoolCol columnIsEqualTo:NO];
    [[[table where].FloatCol columnIsGreaterThanOrEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].FloatCol columnIsBetween:0 and_:0].BoolCol columnIsEqualTo:NO];

    [[[table where].DoubleCol columnIsEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DoubleCol columnIsNotEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DoubleCol columnIsLessThan:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DoubleCol columnIsLessThanOrEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DoubleCol columnIsGreaterThan:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DoubleCol columnIsGreaterThanOrEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DoubleCol columnIsBetween:0 and_:0].BoolCol columnIsEqualTo:NO];

    [[[table where].StringCol columnIsEqualTo:@""].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnIsEqualTo:@"" caseSensitive:NO].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnIsNotEqualTo:@""].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnIsNotEqualTo:@"" caseSensitive:NO].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnBeginsWith:@""].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnBeginsWith:@"" caseSensitive:NO].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnEndsWith:@""].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnEndsWith:@"" caseSensitive:NO].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnContains:@""].BoolCol columnIsEqualTo:NO];
    [[[table where].StringCol columnContains:@"" caseSensitive:NO].BoolCol columnIsEqualTo:NO];

    [[[table where].BinaryCol columnIsEqualTo:bin1].BoolCol columnIsEqualTo:NO];
    [[[table where].BinaryCol columnIsNotEqualTo:bin1].BoolCol columnIsEqualTo:NO];
    [[[table where].BinaryCol columnBeginsWith:bin1].BoolCol columnIsEqualTo:NO];
    [[[table where].BinaryCol columnEndsWith:bin1].BoolCol columnIsEqualTo:NO];
    [[[table where].BinaryCol columnContains:bin1].BoolCol columnIsEqualTo:NO];

    [[[table where].DateCol columnIsEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DateCol columnIsNotEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DateCol columnIsLessThan:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DateCol columnIsLessThanOrEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DateCol columnIsGreaterThan:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DateCol columnIsGreaterThanOrEqualTo:0].BoolCol columnIsEqualTo:NO];
    [[[table where].DateCol columnIsBetween:0 and_:0].BoolCol columnIsEqualTo:NO];

// These are not yet implemented
//    [[[table where].TableCol columnIsEqualTo:nil].BoolCol columnIsEqualTo:NO];
//    [[[table where].TableCol columnIsNotEqualTo:nil].BoolCol columnIsEqualTo:NO];

//    [[[table where].MixedCol columnIsEqualTo:mixInt1].BoolCol columnIsEqualTo:NO];
//    [[[table where].MixedCol columnIsNotEqualTo:mixInt1].BoolCol columnIsEqualTo:NO];
}

#define BOOL_COL 0
#define INT_COL 1
#define FLOAT_COL 2
#define DOUBLE_COL 3
#define STRING_COL 4
#define BINARY_COL 5
#define DATE_COL 6
#define MIXED_COL 7

- (void) testDynamic
{

        TightdbTable *table = [[TightdbTable alloc]init];

        [table addColumnWithType:tightdb_Bool andName:@"BoolCol"];
        [table addColumnWithType:tightdb_Int andName:@"IntCol"];
        [table addColumnWithType:tightdb_Float andName:@"FloatCol"];
        [table addColumnWithType:tightdb_Double andName:@"DoubleCol"];
        [table addColumnWithType:tightdb_String andName:@"StringCol"];
        [table addColumnWithType:tightdb_Binary andName:@"BinaryCol"];
        [table addColumnWithType:tightdb_Date andName:@"DateCol"];
        [table addColumnWithType:tightdb_Mixed andName:@"MixedCol"];
        // TODO: add Enum<T> and Subtable<T> when possible.

        const char bin[4] = { 0, 1, 2, 3 };
        time_t timeNow = [[NSDate date] timeIntervalSince1970];
        TightdbMixed *mixInt1   = [TightdbMixed mixedWithInt64:1];
        TightdbMixed *mixString   = [TightdbMixed mixedWithString:@"foo"];
        TightdbBinary *bin1 = [[TightdbBinary alloc] initWithData:bin size:sizeof bin / 2];
        TightdbBinary *bin2 = [[TightdbBinary alloc] initWithData:bin size:sizeof bin];

        // Using private method just for the sake of testing the setters below.
        [table _addEmptyRows:2];

        [table setBool:YES inColumn:BOOL_COL atRow:0];
        [table setBool:NO inColumn:BOOL_COL atRow:1];

        [table setInt:0 inColumn:INT_COL atRow:0];
        [table setInt:860 inColumn:INT_COL atRow:1];

        [table setFloat:0 inColumn:FLOAT_COL atRow:0];
        [table setFloat:5.6 inColumn:FLOAT_COL atRow:1];

        [table setDouble:0 inColumn:DOUBLE_COL atRow:0];
        [table setDouble:5.6 inColumn:DOUBLE_COL atRow:1];

        [table setString:@"" inColumn:STRING_COL atRow:0];
        [table setString:@"foo" inColumn:STRING_COL atRow:1];

        [table setBinary:bin1 inColumn:BINARY_COL atRow:0];
        [table setBinary:bin2 inColumn:BINARY_COL atRow:1];

        [table setDate:0 inColumn:DATE_COL atRow:0];
        [table setDate:timeNow inColumn:DATE_COL atRow:1];

        [table setMixed:mixInt1 inColumn:MIXED_COL atRow:0];
        [table setMixed:mixString inColumn:MIXED_COL atRow:1];

        // Conditions (note that count is invoked to get the number of matches)

        STAssertEquals([[[table where] column:INT_COL isBetweenInt:859 and_:861] count], (NSUInteger)1, @"betweenInt");
        STAssertEquals([[[table where] column:FLOAT_COL isBetweenFloat:5.5 and_:5.7] count], (NSUInteger)1, @"betweenFloat");
        STAssertEquals([[[table where] column:DOUBLE_COL isBetweenDouble:5.5 and_:5.7] count], (NSUInteger)1, @"betweenDouble");
        STAssertEquals([[[table where] column:DATE_COL isBetweenDate:1 and_:timeNow] count], (NSUInteger)1, @"betweenDate");

        STAssertEquals([[[table where] column:BOOL_COL isEqualToBool:YES] count], (NSUInteger)1, @"isEqualToBool");
        STAssertEquals([[[table where] column:INT_COL isEqualToInt:860] count], (NSUInteger)1, @"isEqualToInt");
        STAssertEquals([[[table where] column:FLOAT_COL isEqualToFloat:5.6] count], (NSUInteger)1, @"isEqualToFloat");
        STAssertEquals([[[table where] column:DOUBLE_COL isEqualToDouble:5.6] count], (NSUInteger)1, @"isEqualToDouble");
        STAssertEquals([[[table where] column:STRING_COL isEqualToString:@"foo"] count], (NSUInteger)1, @"isEqualToString");
        STAssertEquals([[[table where] column:STRING_COL isEqualToString:@"Foo" caseSensitive:NO] count], (NSUInteger)1, @"isEqualToStringCaseNO");
        STAssertEquals([[[table where] column:STRING_COL isEqualToString:@"Foo" caseSensitive:YES] count], (NSUInteger)0, @"isEqualToStringCaseYES");
        STAssertEquals([[[table where] column:DATE_COL isEqualToDate:timeNow] count], (NSUInteger)1, @"isEqualToDate");
        STAssertEquals([[[table where] column:BINARY_COL isEqualToBinary:bin1] count], (NSUInteger)1, @"isEqualToBinary");

        STAssertEquals([[[table where] column:INT_COL isNotEqualToInt:860] count], (NSUInteger)1, @"isEqualToInt");
        STAssertEquals([[[table where] column:FLOAT_COL isNotEqualToFloat:5.6] count], (NSUInteger)1, @"isEqualToFloat");
        STAssertEquals([[[table where] column:DOUBLE_COL isNotEqualToDouble:5.6] count], (NSUInteger)1, @"isEqualToDouble");
        STAssertEquals([[[table where] column:STRING_COL isNotEqualToString:@"foo"] count], (NSUInteger)1, @"isEqualToString");
        STAssertEquals([[[table where] column:STRING_COL isNotEqualToString:@"Foo" caseSensitive:NO] count], (NSUInteger)1, @"isEqualToStringCaseNO");
        STAssertEquals([[[table where] column:STRING_COL isNotEqualToString:@"Foo" caseSensitive:YES] count], (NSUInteger)2, @"isEqualToStringCaseYES");
        STAssertEquals([[[table where] column:DATE_COL isNotEqualToDate:timeNow] count], (NSUInteger)1, @"isEqualToDate");
        STAssertEquals([[[table where] column:BINARY_COL isNotEqualToBinary:bin1] count], (NSUInteger)1, @"isEqualToBinary");

        STAssertEquals([[[table where] column:INT_COL isGreaterThanInt:859] count], (NSUInteger)1, @"isGreaterThanInt");
        STAssertEquals([[[table where] column:FLOAT_COL isGreaterThanFloat:5.5] count], (NSUInteger)1, @"isGreaterThanFloat");
        STAssertEquals([[[table where] column:DOUBLE_COL isGreaterThanDouble:5.5] count], (NSUInteger)1, @"isGreaterThanDouble");
        STAssertEquals([[[table where] column:DATE_COL isGreaterThanDate:0] count], (NSUInteger)1, @"isGreaterThanDate");

        STAssertEquals([[[table where] column:INT_COL isGreaterThanOrEqualToInt:860] count], (NSUInteger)1, @"isGreaterThanInt");
        STAssertEquals([[[table where] column:FLOAT_COL isGreaterThanOrEqualToFloat:5.6] count], (NSUInteger)1, @"isGreaterThanFloat");
        STAssertEquals([[[table where] column:DOUBLE_COL isGreaterThanOrEqualToDouble:5.6] count], (NSUInteger)1, @"isGreaterThanDouble");
        STAssertEquals([[[table where] column:DATE_COL isGreaterThanOrEqualToDate:timeNow] count], (NSUInteger)1, @"isGreaterThanDate");

        STAssertEquals([[[table where] column:INT_COL isLessThanInt:860] count], (NSUInteger)1, @"isLessThanInt");
        STAssertEquals([[[table where] column:FLOAT_COL isLessThanFloat:5.6] count], (NSUInteger)1, @"isLessThanFloat");
        STAssertEquals([[[table where] column:DOUBLE_COL isLessThanDouble:5.6] count], (NSUInteger)1, @"isLessThanDouble");
        STAssertEquals([[[table where] column:DATE_COL isLessThanDate:timeNow] count], (NSUInteger)1, @"isLessThanDate");

        STAssertEquals([[[table where] column:INT_COL isLessThanOrEqualToInt:860] count], (NSUInteger)2, @"isLessThanOrEqualToInt");
        STAssertEquals([[[table where] column:FLOAT_COL isLessThanOrEqualToFloat:5.6] count], (NSUInteger)2, @"isLessThanOrEqualToFloat");
        STAssertEquals([[[table where] column:DOUBLE_COL isLessThanOrEqualToDouble:5.6] count], (NSUInteger)2, @"isLessThanOrEqualToDouble");
        STAssertEquals([[[table where] column:DATE_COL isLessThanOrEqualToDate:timeNow] count], (NSUInteger)2, @"isLessThanOrEqualToDate");

        STAssertEquals([[[table where] column:INT_COL isBetweenInt:859 and_:861] find:0], (size_t) 1, @"find");

        STAssertEquals([[[[table where] column:INT_COL isBetweenInt:859 and_:861] findAll] class], [TightdbView class], @"findAll");

        STAssertEquals([[[table where] minimumWithIntColumn:INT_COL] longLongValue], (int64_t)0, @"minimunIntOfColumn");
        STAssertEquals([[[table where] sumWithIntColumn:INT_COL] longLongValue], (int64_t)860, @"IntCol max");
        /// TODO: Tests missing....

}


- (void)testFind
{
    TightdbTable* table = [[TightdbTable alloc]init];
    [table addColumnWithType:tightdb_Int andName:@"IntCol"];
    [table _addEmptyRows:6];

    [table setInt:10 inColumn:0 atRow:0];
    [table setInt:42 inColumn:0 atRow:1];
    [table setInt:27 inColumn:0 atRow:2];
    [table setInt:31 inColumn:0 atRow:3];
    [table setInt:8  inColumn:0 atRow:4];
    [table setInt:39 inColumn:0 atRow:5];

    STAssertEquals([[[table where] column:0 isBetweenInt:20 and_:40] find:0], (size_t)2,  @"find");
    STAssertEquals([[[table where] column:0 isBetweenInt:20 and_:40] find:3], (size_t)3,  @"find");
    STAssertEquals([[[table where] column:0 isBetweenInt:20 and_:40] find:4], (size_t)5,  @"find");
    STAssertEquals([[[table where] column:0 isBetweenInt:20 and_:40] find:6], (size_t)-1, @"find");
    STAssertEquals([[[table where] column:0 isBetweenInt:20 and_:40] find:3], (size_t)3,  @"find");
    // jjepsen: disabled this test, perhaps it's not relevant after query sematics update.
    //STAssertEquals([[[table where] column:0 isBetweenInt:20 and_:40] find:-1], (size_t)-1, @"find");
}




@end
