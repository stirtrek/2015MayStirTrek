CREATE FUNCTION Sales.fnCalcDistanceMiles( @zip1 varchar(9), @zip2 varchar(9))
RETURNS decimal( 8 , 4 )
AS
BEGIN
    DECLARE
       @d decimal(28,10),@Lat1 decimal(28,10),@Long1 decimal(28,10),@Lat2 decimal(28,10),@Long2 decimal(28,10);
    -- Convert to radians
    SELECT @Lat1 = Lat / 57.2958, @Long1 = Long / 57.2958 FROM Sales.ZipCodes WHERE Zipcode = @zip1
    SELECT @Lat2 = Lat / 57.2958, @Long2 = Long / 57.2958 FROM Sales.ZipCodes WHERE Zipcode = @zip2

    -- Calc distance
    SET @d = SIN( @Lat1 ) * SIN( @Lat2 ) + (COS( @Lat1 ) * COS( @Lat2 ) * COS( @Long2 - @Long1 ));
    -- Convert to miles
    IF @d <> 0
        BEGIN
            SET @d = 3958.75 * ATAN( SQRT( 1 - POWER( @d , 2 )) / @d );
        END;
    RETURN @d;
END; 
GO
SELECT Sales.fnCalcDistanceMiles('44224','90210')