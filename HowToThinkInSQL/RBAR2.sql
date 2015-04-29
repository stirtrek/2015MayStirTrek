CREATE TRIGGER Sales.TR_SpecialOfferIn ON Sales.SpecialOffer
    FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @continue int,
		  @nCount int,
		  @sPrtMsg nvarchar(1024)
    SELECT @continue = count(1) from inserted WHERE Type not in ('No Discount','New Product')
    IF @continue > 0
    BEGIN
	   SELECT @nCount = COUNT(*),
		     @sPrtMsg = '      There is another Special Offer record in effect for ' 
				+ RTRIM( i.Category ) + ' ' + RTRIM( i.Type ) + ' ' 
				+ RTRIM( CONVERT( char , i.StartDate , 1 )) + '-' 
				+ RTRIM( CONVERT( char , i.EndDate , 1 )) + ' ' 
				+ i.DiscountPct + ' Discount               '
              FROM Sales.SpecialOffer r inner join inserted i ON
			 r.Category  = i.Category
                AND r.Type   = i.Type
                AND r.DiscountPct = i.DiscountPct
                AND i.Type NOT IN ('No Discount','New Product')
                AND ((r.StartDate >= i.StartDate
                  AND r.EndDate   <= i.EndDate)
                  OR (r.EndDate   >= i.EndDate
                  AND r.StartDate <= i.StartDate))
		  group by i.Category,i.Type,i.StartDate,i.EndDate,i.DiscountPct
              HAVING COUNT(*) > 1;
            IF @nCount > 1
                BEGIN
                    RAISERROR( @sPrtMsg , 16 , 1 );
                    ROLLBACK TRANSACTION;
                END;
        END;
END;
