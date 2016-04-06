--1�����ӱ�begin---------------------------------------------------------
--֧��������
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_reverse'))
begin
	create table kmmicro_t_reverse (
	   BranchNo             varchar(10)          null,
	   OfflineTradeNo       varchar(50)          null,
	   Status               int                  null,
	   Message              varchar(100)         null,
	   CreateTime           datetime             null,
	   UpdateTime           datetime             null
	)
end
go
--΢�Ų�����־��


if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_trans_log'))
begin
	CREATE TABLE[dbo].[kmmicro_t_trans_log](
		[nflow_id][int]IDENTITY(1,1)NOT NULL,
		[fun][char](1)NOT NULL,
		[type][char](1)NOT NULL,
		[msgc][varchar](4000)NULL,
		[oper_date][datetime]NULL,
		[flag][varchar](1)NULL,
	CONSTRAINT[PK_kmmicro_t_trans_log]PRIMARY KEY CLUSTERED
	(
		[nflow_id]ASC
	)
	)
end 
go

--֧��������
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_reverse'))
begin
	create table kmmicro_t_reverse (
	   BranchNo             varchar(10)          null,
	   OfflineTradeNo       varchar(50)          null,
	   Status               int                  null,
	   Message              varchar(100)         null,
	   CreateTime           datetime             null,
	   UpdateTime           datetime             null
	)
end
go


--3�����Ӵ洢����begin---------------------------------------------------------
--1�洢��������kmmicro_Pr_get_cashno����������


--��;������ͨѶ���ֵ�¼ʱ��ȡ�����µ���������  ----���ô���

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_cashno'))
begin
	drop procedure kmmicro_Pr_get_cashno
end 
go
create procedure kmmicro_Pr_get_cashno
as
begin
	select 1001 as cash_no 
end 
go

--22 ����Ա��¼
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_cashier'))
begin
	drop procedure kmmicro_Pr_get_cashier
end 
go
create procedure kmmicro_Pr_get_cashier(@oper_id varchar(20),@oper_pw varchar(40))
as 
begin 
	declare @count int,
	 	@role_no varchar(12),
		@bflag int,
		@rowcount int
	set @count = 0
	
	if @oper_id = '0000'
	begin 
		select @rowcount = count(*) from sys_t_system where sys_var_id = 'AdminLoginPW' and sys_var_value = @oper_pw
		if @rowcount > 0 set @count = 1
	end
	else
	begin
		select @role_no = role_no from sa_t_operator_info where oper_id =@oper_id and log_pw =@oper_pw  and oper_status = 1
		if len(@role_no) > 0 
		begin
			set @count = 1
		end	
		else
		begin
			set @count = 0
		end
	end
	select @count as qty
end  

go



--10�洢��������kmmicro_pr_get_clslist����������


--��;�����ڻ�ȡ�������ļ���


if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_clslist'))
begin
	drop procedure kmmicro_pr_get_clslist
end 
go
create proc[dbo].[kmmicro_pr_get_clslist](@parent_clsno varchar(50))
as
Begin		
	if len(ltrim(@parent_clsno))=0 or @parent_clsno= '' or  @parent_clsno is null
		select cBigCls_C as ClsNo,cBigCls_N as ClsName,'' as ParentNo from c_t_food_bigCls 
	else
		select cLitCls_C as ClsNo,cLitCls_N as ClsName,cBigCls_C as ParentNo from c_t_food_litCls
		where cBigCls_C=@parent_clsno
		order by ParentNo,ClsNo
End
go



--6�洢��������[kmmicro_pr_get_itemslist]��������@clsno���@keywordģ����ѯ�Ĳ���


--��;�����ڻ�ȡ������Ʒ�б�
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_itemslist'))
begin
	drop procedure kmmicro_pr_get_itemslist
end 
go
create procedure [dbo].[kmmicro_pr_get_itemslist]
	@clsno varchar(50),
	@keyword varchar(200),
	@PageSize		int,				--��ҳ��С
	@CurrentPage	int,				--��Nҳ	
	@TotalSize		int		output		--����������

as
begin
	declare @StartRow int,
			@EndRow   int
	set @StartRow = (@CurrentPage -1) * @PageSize + 1
	set @EndRow = (@CurrentPage -1) * @PageSize + @PageSize

	select identity(int) id, cFood_C FoodNo,cFood_N FoodName,sUnit Unit,nPrc Price into #temp from c_t_food where cLitCls_C like @clsno+'%' and  (cFood_C like '%'+@keyword+'%' or cFood_N like '%'+@keyword+'%')
	--�ܼ�¼��.
	select @TotalSize=max(id) from #temp 
	--��ҳ��ѯ.
    select * from #temp where id between @StartRow and @EndRow
	--�ͷ���ʱ��.
    drop table #temp               
end
go

--�洢��������kmmicro_Pr_get_tabletypelist����������

--��;����ȡ��¥
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_tabletypelist '))
begin
	drop procedure kmmicro_Pr_get_tabletypelist 
end 
go
create procedure [dbo].[kmmicro_Pr_get_tabletypelist] 
as
begin   
	select cFloor_C as ClsNo, cFloor_N as ClsName,'' as ParentNo  from f_t_floor
end


go

--�洢��������kmmicro_Pr_get_tablelistbytypeno����������

--��;��������¥��Ż�ȡ̨λ�б�
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_tablelistbytypeno'))
begin
	drop procedure kmmicro_Pr_get_tablelistbytypeno
end 
go
create procedure [dbo].[kmmicro_Pr_get_tablelistbytypeno]
	@clsno nvarchar(20),
	@PageSize		int,				--��ҳ��С
	@CurrentPage	int,				--��Nҳ	
	@TotalSize		int		output		--����������

as
begin   
	declare @StartRow int,
		    @EndRow   int
	set @StartRow = (@CurrentPage -1) * @PageSize + 1
	set @EndRow = (@CurrentPage -1) * @PageSize + @PageSize
    select identity(int) id, cFloor_C as FoodCls, cTable_C as FoodNo, cTable_N as FoodName,	cFloor_N as FoodClsName  into #temp from f_t_table where  cFloor_C=@clsno
	--�ܼ�¼��.
	select @TotalSize=max(id) from #temp 
	--��ҳ��ѯ.
    select * from #temp where id between @StartRow and @EndRow
	--�ͷ���ʱ��.
    drop table #temp               	
end


go

--�洢��������kmmicro_Pr_get_tableteano����������

--��;����ȡ�������õĲ�λ��Ʒ����.
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_tableteano'))
begin
	drop procedure kmmicro_Pr_get_tableteano
end 
go
create  procedure kmmicro_Pr_get_tableteano
as
begin
	select top 1 food.cfood_c as 'FoodNo' ,food.cfood_n as 'FoodName' from d_t_tabletea tabletea, c_t_food food where food.cfood_c = tabletea.cfood_c
end
go


if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_saleflow'))
begin
	drop procedure kmmicro_Pr_get_saleflow
end 
go
create Procedure [dbo].[kmmicro_Pr_get_saleflow] ( 
	@begin_date	Datetime, 
	@end_date	Datetime, 
	@sale_amt	Numeric(14,4) 
) 
As 
Begin
	Select @sale_amt = Isnull( @sale_amt, 0 )
	select Distinct CardNo,  OpenId,  SheetNo
	From (
	Select Distinct c.card_id As CardNo, i.other3 As OpenId, c.cbill_c As SheetNo From pos_t_vip_cost c, pos_t_vip_info i 
	Where c.card_id = i.card_id And c.oper_date Between @begin_date And @end_date And Abs( c.card_cost ) >= @sale_amt 
	And c.card_way = '����' 
	union all
	select Distinct info.card_id As CardNo, info.other3 As OpenId, bill.cbill_c As SheetNo from d_t_food_bill0 bill, pos_t_vip_info info
	where bill.cVIP_C = info.card_id and 
		 cBill_C not in (select cBill_C from d_t_bill_pay where ePayType <> '��Ա��') and
		bill.dtSettleTime Between @begin_date And @end_date And Abs( bill.nPayAmt ) >= @sale_amt 
	union all 
	select Distinct info.card_id As CardNo, info.other3 As OpenId, bill.cbill_c As SheetNo from d_t_food_bill bill, pos_t_vip_info info
	where bill.cVIP_C = info.card_id and 
		 cBill_C not in (select cBill_C from d_t_bill_pay where ePayType <> '��Ա��') and
		bill.dtSettleTime Between @begin_date And @end_date And Abs( bill.nPayAmt ) >= @sale_amt 
	) FF where  Not Exists ( Select 1 From kmmicro_t_deal_sheetno d Where d.cbill_c = FF.SheetNo )
	
End
go
if exists (select 1 from sysobjects where id = object_id ('wx_pr_getvipinfo'))
begin
	drop procedure wx_pr_getvipinfo
end 
go
create procedure wx_pr_getvipinfo (@as_vipno varchar(20))   
as 
Begin 
SELECT pos_t_vip_info.card_id,   --���� 
 	        pos_t_vip_info.vip_name,   --��Ա����
			pos_t_vip_info.card_type, --��Ա����� 
 	        pos_t_vip_info.vip_sex,   --�Ա� 
 			pos_t_vip_info.vip_idno, --���֤���� 
 	        pos_t_vip_info.vip_add,    --��Ա��ַ 
 	        pos_t_vip_info.job_add,   --������λ 
 	        pos_t_vip_info.vip_zip,  --��Ա�ʱ� 
 	        pos_t_vip_info.vip_tel,   --��Ա�ֻ� 
 	        pos_t_vip_info.vip_mobile,   --��Ա�绰 
 	        pos_t_vip_info.vip_email,   --��Ա���� 
 	        pos_t_vip_info.vip_area,   --��Ա�������� 
 	        pos_t_vip_info.vip_vocation,   --��Ա������ҵ 
 	        pos_t_vip_info.validate_flag,   --�Ƿ�������Ч�ڿ��� 
 	        pos_t_vip_info.vip_start_date,   --��ʼ��Ч�� 
 	        pos_t_vip_info.vip_end_date,   --������Ч�� 
 	        pos_t_vip_info.vip_avocation,   --ҵ�మ�� 
 	        convert(char(10),pos_t_vip_info.vip_birth_date,120) as 'vip_birth_date',  --��������  
 	        convert(char(10),pos_t_vip_info.vip_birth2_date,120) as 'vip_birth2_date', --��������    
 	        pos_t_vip_info.vip_earning,   --��Ա���� 
 	        pos_t_vip_info.vip_favorbrand,   --ϲ����Ʒ��         
 		    '' as cEmp_c, --ҵ��Ա 
 	        --pos_t_vip_info.card_balance,   --��� 
 	        CONVERT(numeric(14,2),dbo.fn_str_xor(pos_t_vip_info.card_sbalance)) as card_balance,    
 	        CONVERT(numeric(14,2),pos_t_vip_info.vip_cons_amount) as vip_cons_amount,   --�ۼ����ѽ�� 
 	        pos_t_vip_info.cons_count,   --�ۼ����Ѵ���      
 	        CONVERT(numeric(14,2),pos_t_vip_info.vip_integral) as vip_integral,  --��ǰ����  
 	        CONVERT(numeric(14,2),pos_t_vip_info.total_integral) as total_integral,  --�ۼƻ���   
 	        CONVERT(numeric(14,2),pos_t_vip_info.card_amount) as card_amount,  --�ۼƳ�ֵ�ܶ�  
 	        (case pos_t_vip_info.card_status when 'N' then 'δ��Ч' when '0' then '����' when '1' then '��Ч' when '2' then '��ʧ' when '3' then '��' else 'δ֪' end ) card_status ,   
 	        pos_t_vip_type.type_name  --�ۼƳ�ֵ�ܶ�  
 	FROM pos_t_vip_info ,pos_t_vip_type  
 	WHERE pos_t_vip_info.card_type =  pos_t_vip_type.type_id and pos_t_vip_info.card_id = @as_vipno  
End 
go
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_cardbalanch'))
begin
	drop procedure kmmicro_Pr_get_cardbalanch
end 
go
create  procedure kmmicro_Pr_get_cardbalanch(@vip_no varchar(20))
as
begin   
	select card_id as cardno, CONVERT(numeric(14,2), dbo.fn_str_xor(card_sbalance))  as card_balance  from pos_t_vip_info where card_id = @vip_no
end
go

if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='pos_t_vip_cost' and syscolumns.name ='num_flag')
begin
	alter table pos_t_vip_cost add num_flag int
end 
go

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_fillmoney'))
begin
	drop procedure kmmicro_Pr_set_fillmoney
end 
go
/*
�������ͽ�� @presentmoney huangzhc 2015-07-08
*/
create   procedure kmmicro_Pr_set_fillmoney(@vip_no varchar(20),@fillmoney Numeric(12,2),@presentmoney Numeric(12,2))
as
begin  
	declare @ls_err         varchar(500),
		@ll_rtn         int,  --����ֵ��1�ɹ���0ʧ��  
		@card_status	Varchar(1),	
		@card_balance	Numeric(12,2),	
		@card_preamt	Numeric(12,2),	
		@dBusinessdt	Datetime,
		@flag varchar(1)
	
	If Isnull(@vip_no, '' ) = ''
	Begin
		set @ls_err = '��Ա���ſ�ֵ�쳣'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If Isnull(@fillmoney, 0 ) = 0
	Begin
		set @ls_err = '��ֵ���Ϊ0�쳣'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If @presentmoney <= 0 or @presentmoney is null
		set @presentmoney = 0
	select @dBusinessdt = sys_var_value from sys_t_system where sys_var_id = 'dBusiness' 

	Select  @card_status = Isnull( pos_t_vip_info.card_status, '' ),
		@card_balance = Isnull( pos_t_vip_info.card_balance, 0 ) + @fillmoney + @presentmoney,
		@flag = pos_t_vip_type.flag_1,
		@card_preamt = Isnull( pos_t_vip_info.nPreAmt, 0 ) From pos_t_vip_info 
	inner join pos_t_vip_type on pos_t_vip_info.card_type  = pos_t_vip_type.type_id
	and card_id = @vip_no
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		set @ls_err = '�������»�Ա��Ϣʧ��:��Ա����(' + @vip_no + ')������'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If @card_status <> '0'
	Begin
		set @ls_err = '��Ա����(' + @vip_no + ')���´��ڷ�����״̬'
		set @ll_rtn = -1 
    		goto rtn 
	End	
	if @flag = '1'
	begin
		set @ls_err = '��Ա����(' + @vip_no + ')����Ϊ������ֵ״̬'
		set @ll_rtn = -1 
    		goto rtn 
	end
	
	update pos_t_vip_info SET card_amount =card_amount + @fillmoney + @presentmoney WHERE card_id = @vip_no
	If @@error <> 0
	Begin
		set @ls_err = '���µǼǻ�Ա����(' + @vip_no + ')����޸�ʧ��(����' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    		goto rtn 
	End

	INSERT INTO pos_t_vip_cost ( oper_id , oper_date , card_id , card_cost , card_way , branch_no , actual_payamt , reverse_desc ,
				 dBusinessdt , bflag , cshift_n , card_balance , PreAmt , cPay_C , trans_flag , Num_flag ) 
       		VALUES ('0000', Getdate(), @vip_no, @fillmoney + @presentmoney, '��ֵ' , '00' , @fillmoney , '΢�ų�ֵ' ,
		@dBusinessdt , 0 , '' , @card_balance , @card_preamt , '01' , '2' , 1  )      
	If @@error <> 0
	Begin
		set @ls_err = '���µǼǻ�Ա����(' + @vip_no + ')ҵ�������ˮʧ��(����' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    		goto rtn 
	End
    	set @ll_rtn = 1 
	
	rtn:
   	If len(@ls_err) > 0 or @ls_err  is not null   
    	raiserror(@ls_err,16,1)  
    	select @ll_rtn   
end
go

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_check_fillcardno'))
begin
	drop procedure kmmicro_Pr_check_fillcardno
end 
go
create   procedure kmmicro_Pr_check_fillcardno(@vip_no varchar(20))
as
begin  
	declare @ls_err         varchar(500),
		@ll_rtn         int,  --����ֵ��1�ɹ���0ʧ��  
		@card_status	Varchar(1),	
		@flag varchar(1)
	
	If Isnull(@vip_no, '' ) = ''
	Begin
		set @ls_err = '��Ա���ſ�ֵ�쳣'
		set @ll_rtn = -1 
    		goto rtn 
	End

	Select  @card_status = Isnull( pos_t_vip_info.card_status, '' ),
		@flag = pos_t_vip_type.flag_1 From pos_t_vip_info 
	inner join pos_t_vip_type on pos_t_vip_info.card_type  = pos_t_vip_type.type_id
	and card_id = @vip_no
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		set @ls_err = '�������»�Ա��Ϣʧ��:��Ա����(' + @vip_no + ')������'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If @card_status <> '0'
	Begin
		set @ls_err = '��Ա����(' + @vip_no + ')���´��ڷ�����״̬'
		set @ll_rtn = -1 
    		goto rtn 
	End	
	if @flag = '1'
	begin
		set @ls_err = '���Ļ�Ա��������ֵ'
		set @ll_rtn = -1 
    		goto rtn 
	end
    	set @ll_rtn = 1 
	
	rtn:
   	If len(@ls_err) > 0 or @ls_err  is not null   
    	raiserror(@ls_err,16,1)  
    	select @ll_rtn   
end
go
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='d_t_bill_pay_alipay0' and syscolumns.name ='cVIP_C')
begin
	alter table d_t_bill_pay_alipay0 add cVIP_C varchar(20) 
end 
go
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='d_t_bill_pay_alipay' and syscolumns.name ='cVIP_C')
begin
	alter table d_t_bill_pay_alipay add cVIP_C varchar(20) 
end 
go
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='d_t_bill_pay_alipay0_tmp' and syscolumns.name ='cVIP_C')
begin
	alter table d_t_bill_pay_alipay0_tmp add cVIP_C varchar(20) 
end 
go


if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_WXPaymentFlow'))
begin
	drop procedure kmmicro_Pr_set_WXPaymentFlow
end 
go
create procedure kmmicro_Pr_set_WXPaymentFlow(@SheetNo varchar(30),@PayStatus char(1),@PayDate smalldatetime,@paytype varchar(10),@cVIP_C varchar(20))
with encryption 
AS 
Begin 
	declare @result int 
	set @paytype = isnull(@paytype,'5') 
	select @result = result from d_t_bill_pay_alipay0 where cbill_guid = @SheetNo 
	if @result <> 2 
    	begin 
		update d_t_bill_pay_alipay0 set result = @PayStatus, responseTime = @PayDate, paytype = @paytype,cVIP_C = @cVIP_C where cbill_guid = @SheetNo
	 End 
End 
go


if exists (select 1 from sysobjects where id = object_id ('wx_pr_getmade'))
begin
	drop procedure wx_pr_getmade
end 
go
create procedure wx_pr_getmade(@as_made varchar(50) ,@as_nqty int ,@as_madedis varchar(255) output ,@as_nExtprice decimal(9,2) output )  
as 
BEGIN 
declare @al_index int 
declare @ls_cmade_c varchar(60),@ls_cmade_n varchar(60) 
declare @ldc_nfee decimal(9,2) 
declare @li_bNUmPrc int,@li_count int 
set @as_madedis = ''  
set @as_nExtprice = 0.00 
If right(@as_made,1) <> ','  
set @as_made = @as_made + ',' 
set @al_index = (charindex(',',@as_made)) 
WHILE @al_index > 0 
Begin 
set  @ls_cmade_c = SUBSTRING ( @as_made , 1 ,@al_index - 1 ) 
select @li_count = Count(cMade_c) from c_v_made where cMade_c = @ls_cmade_c 
If @li_count > 0  
BEGIN 
	select  TOP 1 @ls_cmade_n = cMade_n,@ldc_nfee = nExtprice,@li_bNUmPrc = bNUmPrc from c_v_made where  cMade_c = @ls_cmade_c 
	IF @ldc_nfee > 0  
	BEGIN 
		If @li_bNUmPrc > 0  and @as_nqty > 0 
		BEGIN 
			set @ls_cmade_n = '(' + @ls_cmade_n +'+'+ltrim(rtrim(convert(char,@ldc_nfee))) + 'X'+ltrim(rtrim(convert(char,@as_nqty)))+')' 
			set @ldc_nfee = @ldc_nfee * @as_nqty 
		END 
		ELSE 
		BEGIN 
			set @ls_cmade_n = '(' + @ls_cmade_n  +'+'+ltrim(rtrim(convert(char,@ldc_nfee))) + ')' 
			set @ldc_nfee = @ldc_nfee * @as_nqty   
		END 
	END 
	ELSE 
	BEGIN 
		set @ls_cmade_n = '('+@ls_cmade_n+')' 
		set @ldc_nfee = 0 
	END 
End 
Else 
BEGIN 
	set @ls_cmade_n = '('+@ls_cmade_c+')' 
	set @ldc_nfee = 0 
END 
set @as_nExtprice =  @as_nExtprice + @ldc_nfee 
set @as_madedis = @as_madedis + @ls_cmade_n  
set @as_made = SUBSTRING ( @as_made , @al_index + 1 ,len(@as_made ) - @al_index + 1) 
set @al_index = (charindex(',',@as_made)) 
 
 
End  
END 
go
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='c_t_food_madeCls' and syscolumns.name ='cmade_c')
begin
	alter table c_t_food_madeCls add cmade_c varchar(4)
end 
go


if exists (select 1 from sysobjects where id = object_id ('wx_pr_checktable'))
begin
	drop procedure wx_pr_checktable
end 
go
create procedure wx_pr_checktable (@as_table varchar(12),@type varchar(1),@as_tableno varchar(4) output)  
as  
Begin  
declare @ll_count int  
declare @ll_used int 
declare @ls_msg	 varchar(500) 
declare @ls_dbname varchar(60) 
declare @ls_tableno varchar(4)
set @ls_msg = '' 
if @type = '1'
begin
 	select @ls_dbname = db_name() 
 	select @ll_count = dbo.f_check_app('kmcywdc',@ls_dbname) 
 	if @ll_count < 1 
 	begin 
 	set @ll_count = -1 
 	set @ls_msg = '΢�Ŷ�������δ����,��ȷ��' 
 	goto rtn 
 	end 
end
select top 1 @ls_tableno = cTable_C from f_t_table where cTable_N = @as_table and  bEnabled = 1   
set @ls_tableno = ISNULL(@ls_tableno,'')
set @as_tableno = @ls_tableno

If @ls_tableno <> '' 
BEGIN  
    set @ll_count = 1
	select @ll_used = Count(*) from d_t_Food_bill0 where bSettle = 0 and len(cbill_c) > 9 and cTable_C = @ls_tableno 
	If @ll_used > 0  
	BEGIN 
		set @ll_count = 2 
		--set @ls_msg = '̨λ['+@as_table+']��ռ�ã�����������̨λ��' 
		goto rtn 
	END  
END 
Else 
begin
    set @ll_count = 0
	set @ls_msg = '�����̨λ�����ڣ�����������' 
end
rtn: 
If len(@ls_msg) > 0 
raiserror(@ls_msg,16,1)
select @ll_count   
End
go
if exists (select 1 from sysobjects where id = object_id ('wx_pr_getvipintegral'))
begin
	drop procedure wx_pr_getvipintegral
end 
go
create procedure [dbo].[wx_pr_getvipintegral] (@as_vipno varchar(12),@as_from varchar(20),@as_to varchar(20)) 
as  
begin 
select branch.branch_no, 
	branch.branch_name, 
	convert(char(16),oper_date,120) as 'oper_date',  
	reduce_integral * (case  oper_type when '+' then 1 else -1 end ) reduce_integral , 
	oper_descript 
 from pos_t_integral_operating integral,bi_t_branch_info branch 
where integral.branch_no = branch.branch_no and reduce_integral <> 0  
and  integral.card_id = @as_vipno 
and convert(char(10),oper_date,120)  between @as_from and @as_to  
order by oper_date desc
end 
go
if exists (select 1 from sysobjects where id = object_id ('wx_pr_getvipcost'))
begin
	drop procedure wx_pr_getvipcost
end 
go
create procedure [dbo].[wx_pr_getvipcost] (@as_vipno varchar(12),@as_from varchar(20),@as_to varchar(20)) 
as 
Begin 
select  bi_t_branch_info.branch_no, bi_t_branch_info.branch_name, convert(char(16),pos_t_vip_cost.oper_date,120) as oper_date,--����ʱ�� 
	pos_t_vip_cost.card_cost, --���ѽ��
	pos_t_vip_cost.cbill_c --����
from pos_t_vip_cost , bi_t_branch_info  
where pos_t_vip_cost.branch_no = bi_t_branch_info.branch_no and   pos_t_vip_cost.card_id = @as_vipno and  card_way = '����'  and  
      convert(char(10),pos_t_vip_cost.oper_date,120) between @as_from and @as_to 
	  order by oper_date desc
End  
go
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_insertvip')
	DROP PROCEDURE wx_pr_insertvip
go
create procedure [dbo].[wx_pr_insertvip](@vipname varchar(30),@sex char(5),@viptel char(16),@vipbirth datetime, @pwd char(6),@openid varchar(30) )  
  as  
  begin  
  	declare @vipno varchar(20)  
  	declare @vipnotmp varchar(20),@maxflow int  
  	declare @ls_err varchar(500)  
  	declare @ll_cardlen int  
  	declare @ls_wxviptype char(50)  
  	declare @ls_viptype char(50),@ls_viptypename char(30)  
  	declare @ll_count int  
 	declare @ls_g_branch_no varchar(8) 
  	  
  	select @ll_count = count(card_id) from pos_t_vip_info where isnull(other3,'') = @openid and isnull(@openid,'') <> ''  
  	if @ll_count > 0   
  	BEGIN  
  		set @ls_err = '����΢���Ѿ�ע�����Ա�������ظ�ע��!'  
  		set @vipno = ''  
  		goto rtn  
  	END   
    
  	  
  	select  @ls_g_branch_no = sys_var_value from sys_t_system where sys_var_id = 'g_branch_no' --���ŵ���� 
 	if @ls_g_branch_no is null set @ls_g_branch_no = '' 
 	set @ll_cardlen = len(@ls_g_branch_no) + 8 
  	select  @ls_wxviptype = sys_var_value from sys_t_system where sys_var_id = 'wx_viptype' --΢��Ա������ 
  	If @@error <> 0   
  	BEGIN  
  		set @ls_err = '������Ա����¼ʧ��!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	If @ls_wxviptype = '' or @ls_wxviptype is null   
  	BEGIN  
  		set @ls_err = '��������ʱ������ע���Ա!'  
  		set @vipno = ''  
  		goto rtn   
  	END  
  	--��ȡ��Ա��� ��ʽ ԭ��ʽ������Ա�����룩��Ա�������  �磨01��΢��Ա 
  	set @ls_viptype =ltrim(rtrim( substring(@ls_wxviptype,2,charindex('��',@ls_wxviptype) - charindex('(',@ls_wxviptype) - 1 )))  
  	set @ls_viptypename  = ltrim(rtrim( substring(@ls_wxviptype,charindex('��',@ls_wxviptype)  + 1 ,100)))  
  	--����Ա����Ƿ����  
  	select  @ls_viptype = type_id ,@ls_viptypename = type_name  from pos_t_vip_type where type_id = @ls_viptype  
  	If @@error <> 0   
  	BEGIN  
  		set @ls_err = '������Ա����¼ʧ��!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	if @ls_viptype = '' or @ls_viptype is null   
  	BEGIN  
  		set @ls_err = '���������ڻ�Ա���'+@ls_wxviptype+'!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	select @vipnotmp = Max(card_id) from pos_t_vip_info where card_id like '99'+@ls_g_branch_no+'%' and len(card_id) = @ll_cardlen   
  	If @@error <> 0   
  	BEGIN  
  		set @ls_err = '������Ա��¼ʧ��!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	set @maxflow = convert(int,right(rtrim(@vipnotmp),6 ))  
  	If @maxflow <= 0 or @maxflow is null   set @maxflow = 0  
  	set  @maxflow = @maxflow + 1  
  	set @vipno = '99'+ @ls_g_branch_no + right(rtrim('000000' + convert(char,@maxflow)),6)  
  	--�����Ա card_send_time  
  	insert into pos_t_vip_info (card_id,card_type,card_pwd,vip_name,vip_sex,vip_tel,card_make_flag,card_send_flag,vip_birth_date,other3,ic_cardflag,card_status,validate_flag,back_flag,oper_date,branch_no,vip_start_date,vip_end_date)  
  	values(@vipno,@ls_viptype,@pwd,@vipname,@sex,@viptel,'N','N',@vipbirth,@openid,'O',0,0,1,getdate(), @ls_g_branch_no,getdate(),dateadd(year,1,getdate()) )  
  	If @@error <> 0   
  	BEGIN  
  		set @ls_err = '�����Աϵͳʧ��!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	--����updateһ�λ�Ա��Ϣ�������޷������ŵ�  
  	Update pos_t_vip_info set vip_name = @vipname,vip_sex = @sex ,vip_birth_date = @vipbirth, vip_tel = @viptel 
  	where card_id =  @vipno   
  	select @vipno  
  	return  
  	rtn:  
  	If len(@ls_err) > 0 or @ls_err is null  
  		raiserror(@ls_err,16,1)   
  	select @vipno  
 end  
 go

if exists( select * from sysobjects where xtype = 'P' and name = 'kmmicro_Pr_get_employee')
	DROP PROCEDURE kmmicro_Pr_get_employee
go 
create procedure kmmicro_Pr_get_employee(@emp_type  char(1) = null )
AS 
Begin 
	set @emp_type = isnull(@emp_type,'A')
	if @emp_type = '' set @emp_type = 'A'
   SELECT f_t_employee.cEmp_C, --Ա����� 
	f_t_employee.cEmp_N, --Ա������
	f_t_employee.sSex,   --�Ա�
	f_t_employee.dtBirth,--��������
	f_t_employee.dtJoin, --��ְ����
	f_t_employee.cDept_C,--�������ű�� 
	f_t_employee.cDept_N,--������������ 
	f_t_employee.sContact,--��ϵ��ʽ
	f_t_employee.sPhone,  --�绰
	f_t_employee.sRemark, --��ע
	f_t_employee.bServiceFlag,  --����Ա��־ 0-�� 1-��

	f_t_employee.bSendFlag      --�Ͳ�����
	FROM f_t_employee
	WHERE sstatus = '��ְ'  
	and   ((@emp_type = 'S' and bServiceFlag = 1) or ( @emp_type = 'D' and bSendFlag = 1) or (@emp_type = 'A'))
End
go


if exists(select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_onliePaymentFlow_Pay'))
begin
  drop proc kmmicro_Pr_set_onliePaymentFlow_Pay
end
go
 create procedure kmmicro_Pr_set_onliePaymentFlow_Pay
 (@SheetNo varchar(32), 
  @BranchNo varchar(20), 
  @Amount numeric(9,2), 
  @CreateDate datetime, 
  @WXSheetNo varchar(32),
  @PayType varchar(10),
  @PayResult int ,
  @cVIP_C varchar(20)
	) 
 AS  
 Begin 
    declare @businessdate datetime
 	declare @ll_count int
 	select @businessdate = convert(datetime,sys_var_value,120) 
 	from sys_t_system where sys_var_id = 'dBusiness'
 	select @ll_count = count(*) from d_t_bill_pay_alipay0 where cbill_guid = @SheetNo
 	if @ll_count < 1
 	begin
 	insert into d_t_bill_pay_alipay0 
 	(dbusiness,cbill_c,cbill_guid,requestTime,paytype,
 	nRequestAmt,nRealPayAmt,result,url_2dcode,branchNo,DeliveryMan,paymode,cVIP_C)
  	values(@businessdate,@WXSheetNo,@SheetNo,getdate(),@PayType, 
    @Amount,0.00,@PayResult,'',@BranchNo,'',1,@cVIP_C) 
    end 
 End 
go

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_WXPaymentFlow'))
begin
	drop procedure kmmicro_Pr_get_WXPaymentFlow
end 
go
 create procedure kmmicro_Pr_get_WXPaymentFlow(@SheetNo varchar(32)) 
 with encryption    
 AS  
 Begin 
 select 0 as CustID, 
 	'' as ProductionType, 
 	cbill_guid as 'SheetNo', 
 	BranchNo, 
 	nRequestAmt as 'Amount',  
 	result as  'PayStatus',  
 	requestTime as 'CreateDate',  
 	requestTime as 'PayDate', 
 	DeliveryMan, 
 	'' as 'OnLineOrderID', 
 	'' as 'WXSheetNo', 
 	paytype as 'PayType' 
  	from d_t_bill_pay_alipay0 
 where d_t_bill_pay_alipay0.cbill_guid = @SheetNo 
 End
 go

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_insert_integrate'))
begin
	drop procedure kmmicro_Pr_insert_integrate
end 
go  
create Procedure [dbo].[kmmicro_Pr_insert_integrate] ( 
	@card_id			Varchar(20), 
	@add_integral	Numeric(14,4) 
) 
As 
Begin
	Declare	@err_msg			Varchar(255),
				@card_status	Varchar(1),
				@sum_saleamt	Numeric(14,4),
				@sum_integral	Numeric(14,4),
				@branch_no		Varchar(4),
				@type           varchar(20),
				@mode			varchar(2)
	
	If Isnull( @card_id, '' ) = ''
	Begin
		Select @err_msg = '���ݲ���(card_id)��ֵ�쳣'
		Goto L_ERR
	End
	If Isnull( @add_integral, 0 ) = 0
	Begin
		Select @err_msg = '���ݲ���(add_integral)ȡֵ�쳣'
		Goto L_ERR
	End
	If Isnull( @add_integral, 0 ) > 0
	Begin
		Select @type = '���ӻ���'
		select @mode = '+'
	End
	If Isnull( @add_integral, 0 ) < 0
	Begin
		Select @type = '���ٻ���'
		select @mode = '-'
		select @add_integral = @add_integral * -1
	End
	
	Select @card_status = Isnull( card_status, '' ), @sum_saleamt = Isnull( vip_cons_amount, 0 ), @sum_integral = Isnull( total_integral, 0 ) 
	From pos_t_vip_info Where card_id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '�������»�Ա��Ϣʧ��:��Ա����(' + @card_id + ')������'
		Goto L_ERR
	End
	If @card_status <> '0'
	Begin
		Select @err_msg = '��Ա����(' + @card_id + ')���´��ڷ�����״̬'
		Goto L_ERR
	End
	if @sum_integral < @add_integral and @mode = '-'
	begin
		Select @err_msg = '��Ա����(' + @card_id + ')�Ļ������ڼ������۵Ļ���'
		Goto L_ERR
	end
	
	Select @branch_no = Left( sys_var_value, 4 ) From sys_t_system Where sys_var_id = 'g_branch_no'
	
	Begin Tran T1
	
	Insert Into pos_t_integral_operating (card_id, oper_type, oper_date, oper_id, oper_descript, 
		sum_saleamt, sum_integral, reduce_amt, reduce_integral, memo, other1, branch_no) 
	Values (@card_id, @mode, Getdate(), '0000', @type+'[' + Convert( Varchar, Convert( Int, @add_integral ) ) + ']--��Ա[' + @card_id + ']', 
		@sum_saleamt, @sum_integral, 0, @add_integral, '�ֹ��Ӽ�', '', @branch_no)
	If @@error <> 0
	Begin
		Select @err_msg = '���µǼǻ�Ա����(' + @card_id + ')���ֲ�����ˮʧ��(����' + Convert( Varchar, @@error ) + ')'
		Goto L_ROLLBACK
	End
	
	Commit Tran T1
	Return 0
	
L_ROLLBACK:
	Rollback Tran T1
	
L_ERR:
	Raiserror(@err_msg, 16, 1)
	Return -1
End
go
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_check_integrate'))
begin
	drop procedure kmmicro_Pr_check_integrate
end 
go
create Procedure [dbo].[kmmicro_Pr_check_integrate] ( 
	@card_id			Varchar(20), 
	@add_integral	Numeric(14,4) 
) 
As 
Begin
		Declare	@err_msg		Varchar(255),
				@card_status	Varchar(1),
				@sum_integral	Numeric(14,4),
				@ll_rtn         int  --����ֵ��1�ɹ���0ʧ��  
	If Isnull( @card_id, '' ) = ''
	Begin
		Select @err_msg = '���ݲ���(card_id)��ֵ�쳣'
		set @ll_rtn = -1 
		Goto L_ERR
	End
	If Isnull( @add_integral, 0 ) = 0
	Begin
		Select @err_msg = '���ݲ���(add_integral)ȡֵ�쳣'
		set @ll_rtn = -1 
		Goto L_ERR
	End
		
	Select @card_status = Isnull( card_status, '' ), @sum_integral = Isnull( total_integral, 0 ) 
	From pos_t_vip_info Where card_id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '�������»�Ա��Ϣʧ��:��Ա����(' + @card_id + ')������'
		set @ll_rtn = -1 
		Goto L_ERR
	End
	If @card_status <> '0'
	Begin
		Select @err_msg = '��Ա����(' + @card_id + ')���´��ڷ�����״̬'
		set @ll_rtn = -1 
		Goto L_ERR
	End
	If Isnull( @add_integral, 0 ) < 0
	Begin
		select @add_integral = @add_integral * -1
	End
	if @sum_integral < @add_integral
	begin
		Select @err_msg = '��Ա����(' + @card_id + ')�Ļ������ڼ������۵Ļ���'
		set @ll_rtn = -1 
		Goto L_ERR
	end
	set @ll_rtn = 1 
	
L_ERR:
	If len(@err_msg) > 0 or @err_msg  is not null   
    	raiserror(@err_msg,16,1)  
	select @ll_rtn   
End
go
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_unbindCard'))
begin
	drop procedure kmmicro_Pr_set_unbindCard
end 
go
create procedure kmmicro_Pr_set_unbindCard(@cardno varchar(30))
with encryption 
AS 
Begin 
update pos_t_vip_info set other3='' where card_id = @cardno
End 
go

 --���ݻ�Ա���ţ�ԭ���룬 �޸�����
--��������Ա���š�ԭ���롢������
--exec kmmicro_Pr_alter_vip_pw '0100002', '', '������'
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_alter_vip_pw'))
begin
	drop procedure kmmicro_Pr_alter_vip_pw
end 
go

create procedure kmmicro_Pr_alter_vip_pw(
	@cardid varchar(20),          --��Ա����
	@oldpw varchar(6),     --ԭ����

	@newpw varchar(6)      --������

)
as
begin 
	declare	@card_pw		varchar(6),
	        @ll_count		int,
	        @ls_err         varchar(500),     --������Ϣ
			@ll_rtn         int,              --����ֵ��1�ɹ���0ʧ��  
			@computer		varchar(50)		--�������
	
	select @computer = hostname from master.dbo.sysprocesses where spid=@@spid
	
	select @ll_count = count(1) from pos_t_vip_info where card_id = @cardid;
	
	if @ll_count < 1
	begin
		set @ls_err = '��Ա���Ų�����'
		set @ll_rtn = -1 
    	goto rtn 
	end
	
	if @oldpw = @newpw
	begin
		set @ls_err = '�������ԭ���벻����ͬ'
		set @ll_rtn = -1 
    	goto rtn 
	end
	
	select @card_pw = card_pwd from pos_t_vip_info where card_id = @cardid
	
	if @card_pw is not null or @oldpw <> ''
	begin
		if @card_pw <> @oldpw
		begin
			set @ls_err = 'ԭ�������'
			set @ll_rtn = -1 
    		goto rtn 
		end
	end
	
	update pos_t_vip_info set card_pwd = @newpw where card_id = @cardid
	
	--д�޸Ļ�Ա������־

	insert into sa_t_operate_log ( oper_id, oper_sys, oper_time,fun_id,fun_name,oper_str,bill_type,bill_no,oper_remark,oper_computer)
	values ('0000','09',getdate(),'�����޸�����','���Ŀ�����','��Ա���Ŀ���','','','΢�������޸Ļ�Ա����:ԭ����[' + @oldpw + '],������[' + @newpw + ']',@computer)
	
	rtn:
   	If len(@ls_err) > 0 or @ls_err  is not null   
    	raiserror(@ls_err,16,1)  
    	select @ll_rtn   
end
go