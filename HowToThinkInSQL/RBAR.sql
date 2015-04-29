DROP TRIGGER [dbo].[TR_RmRentsIn]


GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

CREATE TRIGGER DBO.TR_RmRentsIn on RmRents   for insert AS /* */
/* **************************************************************************/
/* * Management Reports Inc.  -RmRentsIn                                    */
/* * Date Written - 03/17/03 John Grega                                     */
/* * Date Revised - 04/08/03                                                */
/* *                Revised Error messgae to be more readable               */
/* *                                                                        */
/* *                                                                        */
/* * Check insert for duplicate active records                              */
/* *                                                                        */
/* **************************************************************************/
/*  */
                                  
SET NOCOUNT on 
/* ****** set conditions for trigger -  */

Begin
/* ****** Setup Cursor for Prospect */
  DECLARE RmRentsCursor cursor FOR 
  SELECT  i.id, i.rmpropid, i.classid, i.startdt, i.enddt, i.leasetype, i.term, i.active
          from inserted as i 
   
 DECLARE @nIdn as numeric,
 @sRmPropIdn as char(6),
 @sClassIdn as char(10),
 @dtStartDtn as datetime,
 @dtEndDtn as datetime,
 @sLeaseTypen as char(1),
 @nTermn as numeric,
 @sActiven as char(1),
 @nCount as numeric,
 @sPrtMsg as char(200)

 OPEN RmRentsCursor
 FETCH NEXT from RmRentsCursor into @nIdn, @sRmPropIdn, @sClassIdn, @dtStartDtn, @dtEndDtn, @sLeaseTypen,@nTermn,@sActiven
                                 
 WHILE @@fetch_status = 0   
 BEGIN 

 If @sActiven = 'N'
    goto SkipRmRents
 If @sActiven = 'P'
    goto SkipRmRents

 Select @nCount=0
 Select @nCount=count(*) from rmrents where rmpropid=@sRmPropIdn and classid=@sClassIdn  and leasetype=@sLeaseTypen and term=@nTermn and active ='Y'and ((startdt>=@dtStartDtn and enddt<=@dtEndDtn) or (enddt>=@dtStartDtn and startdt<@dtEndDtn)) having count(*)>1
 If @nCount > 1 
    Begin
 Select @sPrtMsg='      There is another Rents records in effect for '+RTrim(@sRmpropIdn)+' '+RTrim(@sClassIdn)+' '+RTrim(convert(char,@dtStartDtn,1))+'-'+RTrim(convert(char,@dtEndDtn,1))+' '+@sLeaseTypen+' Term-'+RTrim(convert(char, @nTermn,1))+ '               '
    Raiserror(@sPrtMsg,16,1)
    ROLLBACK TRANSACTION 
    GOTO SkipRmRents
    End

SkipRmRents: 

   FETCH NEXT from RmRentsCursor into @nIdn, @sRmPropIdn, @sClassIdn, @dtStartDtn, @dtEndDtn, @sLeaseTypen,@nTermn,@sActiven
                
   END

close RmRentsCursor
deallocate RmRentsCursor
END

GO