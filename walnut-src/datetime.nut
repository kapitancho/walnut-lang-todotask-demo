module datetime:

Clock = :[];
InvalidDate = :[];

Date <: [year: Integer, month: Integer<1..12>, day: Integer<1..31>] @ InvalidDate :: {
    ?whenValueOf(#.day) is {
        31: ?whenTypeOf(#.month) is {
            type{Integer[2, 4, 6, 9, 11]}: => Error(InvalidDate[]),
            ~: null
        },
        30: ?whenTypeOf(#.month) is {
            type{Integer[2]}: => Error(InvalidDate[]),
            ~: null
        },
        29: ?whenTypeOf(#.month) is {
            type{Integer[2]}: ?whenIsTrue {
                {#.year % 4} > 0: => Error(InvalidDate[]),
                {#.year % 100} == 0: ?whenIsTrue {
                    {#.year % 400} > 0: => Error(InvalidDate[]),
                    ~: null
                },
                ~: null
            },
            ~: null
        },
        ~: null
    }
};
Time <: [hour: Integer<0..23>, minute: Integer<0..59>, second: Integer<0..59>];
DateAndTime <: [date: Date, time: Time];