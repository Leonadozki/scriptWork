﻿if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='c_t_food_madeCls' and syscolumns.name ='cmade_c')
begin
	alter table c_t_food_madeCls add cmade_c varchar(4)
end 
go

if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='pos_t_vip_cost' and syscolumns.name ='num_flag')
begin
	alter table pos_t_vip_cost add num_flag int
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

--1、增加表begin---------------------------------------------------------
--微信操作日志表

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
--支付撤销表
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
--增加表end-----------------------------------------------------------


--3、增加存储过程begin---------------------------------------------------------
--1存储过程名：kmmicro_Pr_get_cashno，参数：无

--用途：用于通讯助手登录时获取到线下的收银机号  ----不用处理

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

--22 操作员登录if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_cashier'))
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


--2存储过程名：kmmicro_Pr_get_itemcls，参数：无

--用途：用于通讯助手类别维护时查询已新增的类别

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_itemcls'))
begin
	drop procedure kmmicro_Pr_get_itemcls
end 
go
create procedure kmmicro_Pr_get_itemcls
as
begin   
	--select cLitCls_C as ClsNo,cLitCls_N as ClsName,cBigCls_C as ParentNo,cBigCls_N as ParentName from c_t_food_litCls
	select item_clsno as ClsNo,item_clsname as ClsName,parent_no as ParentNo from kmmicro_t_item_cls
end
go


--7存储过程名：kmmicro_pr_get_itemno，参数：@item_no商品编码
--用途：用于获取线下商品信息
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_itemno'))
begin
	drop procedure kmmicro_pr_get_itemno
end 
go
create procedure kmmicro_pr_get_itemno(@item_no varchar(20))

as
begin
	select cFood_C as ItemNo,cFood_N as ItemName,cLitCls_C as ItemClsNo,sUnit as ItemUnit,'' as ItemSize,nPrc as Price from c_t_food where cFood_C=@item_no order by cFood_C asc
end
go

--20存储过程名：kmmicro_Pr_get_itemfilename 参数： 


--10存储过程名：kmmicro_pr_get_clslist，参数：无

--用途：用于获取先下类别的级数

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



--6存储过程名：[kmmicro_pr_get_itemslist]，参数：@clsno类别，@keyword模糊查询的参数

--用途：用于获取线下商品列表
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_itemslist'))
begin
	drop procedure kmmicro_pr_get_itemslist
end 
go
create procedure [dbo].[kmmicro_pr_get_itemslist]
	@clsno varchar(50),
	@keyword varchar(200),
	@PageSize		int,				--分页大小
	@CurrentPage	int,				--第N页	
	@TotalSize		int		output		--返回总行数
as
begin
	declare @StartRow int,
			@EndRow   int
	set @StartRow = (@CurrentPage -1) * @PageSize + 1
	set @EndRow = (@CurrentPage -1) * @PageSize + @PageSize
	if @keyword is null  
		set @keyword = '' 
	select identity(int) id, cFood_C FoodNo,cFood_N FoodName,sUnit Unit,nPrc Price into #temp from c_t_food 
	where  
	(@keyword <> '' and ( cFood_C like '%'+@keyword+'%' or cFood_N like '%'+@keyword+'%'))
	or 
	(@keyword = '' and cLitCls_C like @clsno+'%')
	--总记录数.
	select @TotalSize=max(id) from #temp 
	--分页查询.
    select * from #temp where id between @StartRow and @EndRow
	--释放临时表.
    drop table #temp               
end
go


--存储过程名：kmmicro_Pr_get_tabletypelist，参数：无
--用途：获取厅楼
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

--存储过程名：kmmicro_Pr_get_tablelistbytypeno，参数：无
--用途：根据厅楼编号获取台位列表
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_tablelistbytypeno'))
begin
	drop procedure kmmicro_Pr_get_tablelistbytypeno
end 
go
create procedure [dbo].[kmmicro_Pr_get_tablelistbytypeno]
	@clsno nvarchar(20),
	@PageSize		int,				--分页大小
	@CurrentPage	int,				--第N页	
	@TotalSize		int		output		--返回总行数
as
begin   
	declare @StartRow int,
		    @EndRow   int
	set @StartRow = (@CurrentPage -1) * @PageSize + 1
	set @EndRow = (@CurrentPage -1) * @PageSize + @PageSize
    select identity(int) id, cFloor_C as FoodCls, cTable_C as FoodNo, cTable_N as FoodName,	cFloor_N as FoodClsName  into #temp from f_t_table where  cFloor_C=@clsno
	--总记录数.
	select @TotalSize=max(id) from #temp 
	--分页查询.
    select * from #temp where id between @StartRow and @EndRow
	--释放临时表.
    drop table #temp               	
end


go

--存储过程名：kmmicro_Pr_get_tableteano，参数：无
--用途：获取线下设置的茶位出品编码.
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
	And c.card_way = '消费' 
	union all
	select Distinct info.card_id As CardNo, info.other3 As OpenId, bill.cbill_c As SheetNo from d_t_food_bill0 bill, pos_t_vip_info info
	where bill.cVIP_C = info.card_id and 
		 cBill_C not in (select cBill_C from d_t_bill_pay where ePayType <> '会员卡') and
		bill.dtSettleTime Between @begin_date And @end_date And Abs( bill.nPayAmt ) >= @sale_amt 
	union all 
	select Distinct info.card_id As CardNo, info.other3 As OpenId, bill.cbill_c As SheetNo from d_t_food_bill bill, pos_t_vip_info info
	where bill.cVIP_C = info.card_id and 
		 cBill_C not in (select cBill_C from d_t_bill_pay where ePayType <> '会员卡') and
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
SELECT pos_t_vip_info.card_id,   --卡号 
 	        pos_t_vip_info.vip_name,   --会员名称
			pos_t_vip_info.card_type, --会员卡类别 
 	        pos_t_vip_info.vip_sex,   --性别 
 			pos_t_vip_info.vip_idno, --身份证号码 
 	        pos_t_vip_info.vip_add,    --会员地址 
 	        pos_t_vip_info.job_add,   --工作单位 
 	        pos_t_vip_info.vip_zip,  --会员邮编 
 	        pos_t_vip_info.vip_tel,   --会员手机 
 	        pos_t_vip_info.vip_mobile,   --会员电话 
 	        pos_t_vip_info.vip_email,   --会员邮箱 
 	        pos_t_vip_info.vip_area,   --会员所属区域 
 	        pos_t_vip_info.vip_vocation,   --会员所在行业 
 	        pos_t_vip_info.validate_flag,   --是否起用有效期控制 
 	        pos_t_vip_info.vip_start_date,   --开始有效期 
 	        pos_t_vip_info.vip_end_date,   --结束有效期 
 	        pos_t_vip_info.vip_avocation,   --业余爱好 
 	        convert(char(10),pos_t_vip_info.vip_birth_date,120) as 'vip_birth_date',  --阳历生日  
 	        convert(char(10),pos_t_vip_info.vip_birth2_date,120) as 'vip_birth2_date', --阴历生日    
 	        pos_t_vip_info.vip_earning,   --会员收入 
 	        pos_t_vip_info.vip_favorbrand,   --喜欢的品牌         
 		    '' as cEmp_c, --业务员 
 	        --pos_t_vip_info.card_balance,   --余额 
 	        CONVERT(numeric(14,2),dbo.fn_str_xor(pos_t_vip_info.card_sbalance)) as card_balance,    
 	        CONVERT(numeric(14,2),pos_t_vip_info.vip_cons_amount) as vip_cons_amount,   --累计消费金额 
 	        pos_t_vip_info.cons_count,   --累计消费次数      
 	        CONVERT(numeric(14,2),pos_t_vip_info.vip_integral) as vip_integral,  --当前积分  
 	        CONVERT(numeric(14,2),pos_t_vip_info.total_integral) as total_integral,  --累计积分   
 	        CONVERT(numeric(14,2),pos_t_vip_info.card_amount) as card_amount,  --累计充值总额  
 	        (case pos_t_vip_info.card_status when 'N' then '未生效' when '0' then '正常' when '1' then '无效' when '2' then '挂失' when '3' then '收' else '未知' end ) card_status ,   
 	        pos_t_vip_type.type_name  --累计充值总额  
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
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_fillmoney'))
begin
	drop procedure kmmicro_Pr_set_fillmoney
end 
go
/*
增加赠送金额 @presentmoney huangzhc 2015-07-08
*/
create   procedure kmmicro_Pr_set_fillmoney(@vip_no varchar(20),@fillmoney Numeric(12,2),@presentmoney Numeric(12,2))
as
begin  
	declare @ls_err         varchar(500),
		@ll_rtn         int,  --返回值：1成功，0失败  
		@card_status	Varchar(1),	
		@card_balance	Numeric(12,2),	
		@card_preamt	Numeric(12,2),	
		@dBusinessdt	Datetime,
		@flag 		varchar(1),
		@icflag		varchar(1)
	
	If Isnull(@vip_no, '' ) = ''
	Begin
		set @ls_err = '会员卡号空值异常'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If Isnull(@fillmoney, 0 ) = 0
	Begin
		set @ls_err = '充值金额为0异常'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If @presentmoney <= 0 or @presentmoney is null
		set @presentmoney = 0
	select @dBusinessdt = sys_var_value from sys_t_system where sys_var_id = 'dBusiness' 

	Select  @card_status = Isnull( pos_t_vip_info.card_status, '' ),
		@card_balance = Isnull( pos_t_vip_info.card_balance, 0 ) + @fillmoney + @presentmoney,
		@flag = pos_t_vip_type.flag_1,@icflag = ic_cardflag,
		@card_preamt = Isnull( pos_t_vip_info.nPreAmt, 0 ) From pos_t_vip_info 
	inner join pos_t_vip_type on pos_t_vip_info.card_type  = pos_t_vip_type.type_id
	and card_id = @vip_no
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		set @ls_err = '检索线下会员信息失败:会员卡号(' + @vip_no + ')不存在'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If @card_status <> '0'
	Begin
		set @ls_err = '会员卡号(' + @vip_no + ')线下处于非正常状态'
		set @ll_rtn = -1 
    		goto rtn 
	End	
	if @flag = '1'
	begin
		set @ls_err = '会员卡号(' + @vip_no + ')线下为不允许储值状态'
		set @ll_rtn = -1 
    		goto rtn 
	end

	if @icflag = 'I'
	begin
		set @ls_err = '会员卡号(' + @vip_no + ')为IC卡，不支持线上充值'
		set @ll_rtn = -1 
    		goto rtn 
	end
	
	update pos_t_vip_info SET card_amount =card_amount + @fillmoney + @presentmoney WHERE card_id = @vip_no
	If @@error <> 0
	Begin
		set @ls_err = '线下登记会员卡号(' + @vip_no + ')金额修改失败(代码' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    		goto rtn 
	End

	INSERT INTO pos_t_vip_cost ( oper_id , oper_date , card_id , card_cost , card_way , branch_no , actual_payamt , reverse_desc ,
				 dBusinessdt , bflag , cshift_n , card_balance , PreAmt , cPay_C ,  Num_flag ) 
       		VALUES ('0000', Getdate(), @vip_no, @fillmoney + @presentmoney, '充值' , '00' , @fillmoney , '微信充值' ,
		@dBusinessdt , 0 , '' , @card_balance , @card_preamt , '01'  , 1  )      
	If @@error <> 0
	Begin
		set @ls_err = '线下登记会员卡号(' + @vip_no + ')业务操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
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
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_order_insert_detail'))
begin
	drop procedure kmmicro_pr_order_insert_detail
end 
go
create procedure kmmicro_pr_order_insert_detail(@order_id varchar(30),@cfood_c varchar(30),@cfood_n  varchar(70),   
                                              @nqty numeric(16,4),@sunit varchar(30),   
                                                                                                       @sMade varchar(30),@nPrc numeric(16,4) )   
as   
begin   
        declare        
                  @ll_rowcount int,   
                  @ls_seller_usernick         varchar(32),   
                  @ls_branch_no                 varchar(8),   
                  @eSuitFlag                         varchar(4),   
                  @cfoodbill                           varchar(4),   
			   @li_bsuitfood					int,   
			   @ld_dbusiness                    varchar(20),   
			   @ls_sunit                        varchar(30),   
			   @ls_madedisplay                        varchar(255),   
			   @ldc_nexprice                       decimal(9,2)   
        select @ls_branch_no = sys_var_value from sys_t_system where sys_var_id = 'g_branch_no';   
 	   set @ls_seller_usernick = '' 
    select @ld_dbusiness = sys_var_value from sys_t_system where sys_var_id = 'dBusiness';   
     select convert(datetime,@ld_dbusiness )   
   /* 
        if len(isnull(@ls_seller_usernick ,'')) =0    
        begin   
                  raiserror('获取卖家账号失败，无法核销订单！',16,1)   
                  return    
        end   
   */ 
        select @ll_rowcount = count(*) from wx_t_order_master0 where orderid = @order_id;   
        if @@error <> 0 or @ll_rowcount < 1    
        begin   
                  raiserror('读取订单单头信息失败！',16,1)   
                  return    
        end   
--淘宝接口变更，如果没有例牌，取本地默认例牌   
	select @li_bsuitfood = bsuitfood,@ls_sunit =sunit from c_t_food where cfood_c = @cfood_c ;   
	if @@rowcount = 0    
	begin   
		Raiserror('餐饮门店无此菜品或已下架，无法下单！',16,1)   
		return    
	end   
	if len(ltrim(rtrim(isnull(@sunit,'')))) = 0    or isnull(@li_bsuitfood,0) = 1    
	begin   
		set @sunit = @ls_sunit   
	end   
	if @sMade = '默认'  
	begin  
		set @sMade = ''  
	end  
	if len(ltrim(rtrim(isnull(@smade,'')))) = 0    
	begin   
		set @smade = ''   
	end   
		Else 
		BEGIN 
			exec wx_pr_getmade @smade ,@nqty,@ls_madedisplay output, @ldc_nexprice output 
		END 

	 --检查台位是否存在    
	 set @ll_rowcount = 0     
	 select @ll_rowcount = count(*) from wx_t_order_detail0  where cfood_c = @cfood_c and sunit = @sunit and orderid = @order_id and isnull(sMade,'') = @sMade;   
	 if @ll_rowcount > 0    
	 begin   
			update wx_t_order_detail0    
			set nPrc = @nprc   
			where orderid = @order_id and cfood_c = @cfood_c and sunit = @sunit and isnull(smade,'') = @smade;   
		if @@error <> 0    
		begin   
		 	raiserror('更新订单出品价格信息失败！',16,1)   
            	return    
		end   
		------------返回订单   
		return    
	 end	   
	if isnull(@li_bsuitfood,0) = 1    
			set @eSuitFlag = '套餐'   

	else   
			set @eSuitFlag = '单品'   
  
        select @cfoodbill = max(cfoodbill)  from wx_t_order_detail0 where orderid = @order_id;   
        if @@error <> 0                   
        begin   
           raiserror('读取菜品点单序号失败！',16,1)   
           return    
        end   
        if len(isnull(@cfoodbill,'')) = 0    
                  set @cfoodbill = '0101'   
        else   
                  set @cfoodbill =  left(@cfoodbill,2) + right( '00' + convert(varchar(2),convert(int,right(@cfoodbill,2)) + 1)  ,2)    
        insert into wx_t_order_detail0(dbusiness,orderid,cfoodbill,cfood_c,cfood_n,eSuitFlag,eSuitBill,nQty,sunit,sMade,nPrc,nExprc,smadedisplay)   
                                                         values(@ld_dbusiness,@order_id,@cfoodbill,@cfood_c, @cfood_n,@eSuitFlag,@cfoodbill,@nqty ,@sunit,@sMade,@nprc, @ldc_nexprice ,@ls_madedisplay )   
        if @@error <> 0    
        begin   
	           raiserror('订单单体插入菜品信息失败！',16,1)   
	           return    
        end   
return   
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
		@ll_rtn         int,  --返回值：1成功，0失败  
		@card_status	Varchar(1),	
		@flag varchar(1)
	
	If Isnull(@vip_no, '' ) = ''
	Begin
		set @ls_err = '会员卡号空值异常'
		set @ll_rtn = -1 
    		goto rtn 
	End

	Select  @card_status = Isnull( pos_t_vip_info.card_status, '' ),
		@flag = pos_t_vip_type.flag_1 From pos_t_vip_info 
	inner join pos_t_vip_type on pos_t_vip_info.card_type  = pos_t_vip_type.type_id
	and card_id = @vip_no
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		set @ls_err = '检索线下会员信息失败:会员卡号(' + @vip_no + ')不存在'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If @card_status <> '0'
	Begin
		set @ls_err = '会员卡号(' + @vip_no + ')线下处于非正常状态'
		set @ll_rtn = -1 
    		goto rtn 
	End	
	if @flag = '1'
	begin
		set @ls_err = '您的会员卡不允许储值'
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
 	set @ls_msg = '微信订单服务未开启,请确认' 
 	goto rtn 
 	end 
	select top 1 @ls_tableno = cTable_C from f_t_table where cTable_N = @as_table and  bEnabled = 1 
end
Else
begin
	select top 1 @ls_tableno = cTable_C from f_t_table where cTable_c = @as_table and  bEnabled = 1 
end
  
set @ls_tableno = ISNULL(@ls_tableno,'')
set @as_tableno = @ls_tableno

If @ls_tableno <> '' 
BEGIN  
    set @ll_count = 1
	select @ll_used = Count(*) from d_t_Food_bill0 where bSettle = 0 and len(cbill_c) > 9 and cTable_C = @ls_tableno 
	If @ll_used > 0  
	BEGIN 
		set @ll_count = 2 
		--set @ls_msg = '台位['+@as_table+']被占用，请输入其他台位！' 
		goto rtn 
	END  
END 
Else 
begin
    set @ll_count = 0
	set @ls_msg = '输入的台位不存在，请重新输入' 
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
	select @as_from = @as_from + ' ' + '00:00:00'
	select @as_to = @as_to + ' ' + '23:59:59'

        select  substring(cBill_C,1,2) as branch_no,
		(select branch_name from bi_t_branch_info where branch_no = substring(cBill_C,1,2)) as branch_name,
                 convert(char(10),dtSettleTime,120) as oper_date,--消费时间 
		 nOughtAmt as card_cost, -- 消费金额
		 cbill_c  -- 单据号
	from d_t_food_Bill0
	where cVIP_C = @as_vipno and dtSettleTime between @as_from and @as_to and bSettle = 1
        
        union 

	select  substring(cBill_C,1,2) as branch_no,
		(select branch_name from bi_t_branch_info where branch_no = substring(cBill_C,1,2)) as branch_name,
                 convert(char(10),dtSettleTime,120) as oper_date,--消费时间 
		 nOughtAmt as card_cost,   -- 消费金额
		 cbill_c    -- 单据号
	from d_t_food_Bill
	where cVIP_C = @as_vipno and dtSettleTime between @as_from and @as_to
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
  		set @ls_err = '您的微信已经注册过会员，不能重复注册!'  
  		set @vipno = ''  
  		goto rtn  
  	END   
    
  	  
  	select  @ls_g_branch_no = sys_var_value from sys_t_system where sys_var_id = 'g_branch_no' --本门店编码 
 	if @ls_g_branch_no is null set @ls_g_branch_no = '' 
 	set @ll_cardlen = len(@ls_g_branch_no) + 8 
  	select  @ls_wxviptype = sys_var_value from sys_t_system where sys_var_id = 'wx_viptype' --微会员归属类 
  	If @@error <> 0   
  	BEGIN  
  		set @ls_err = '检索会员类别记录失败!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	If @ls_wxviptype = '' or @ls_wxviptype is null   
  	BEGIN  
  		set @ls_err = '本机构暂时不允许注册会员!'  
  		set @vipno = ''  
  		goto rtn   
  	END  
  	--截取会员类别 格式 原格式：（会员类别编码）会员类别名称  如（01）微会员 
  	set @ls_viptype =ltrim(rtrim( substring(@ls_wxviptype,2,charindex('）',@ls_wxviptype) - charindex('(',@ls_wxviptype) - 1 )))  
  	set @ls_viptypename  = ltrim(rtrim( substring(@ls_wxviptype,charindex('）',@ls_wxviptype)  + 1 ,100)))  
  	--检查会员类别是否存在  
  	select  @ls_viptype = type_id ,@ls_viptypename = type_name  from pos_t_vip_type where type_id = @ls_viptype  
  	If @@error <> 0   
  	BEGIN  
  		set @ls_err = '检索会员类别记录失败!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	if @ls_viptype = '' or @ls_viptype is null   
  	BEGIN  
  		set @ls_err = '餐饮不存在会员类别'+@ls_wxviptype+'!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	select @vipnotmp = Max(card_id) from pos_t_vip_info where card_id like '99'+@ls_g_branch_no+'%' and len(card_id) = @ll_cardlen   
  	If @@error <> 0   
  	BEGIN  
  		set @ls_err = '检索会员记录失败!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	set @maxflow = convert(int,right(rtrim(@vipnotmp),6 ))  
  	If @maxflow <= 0 or @maxflow is null   set @maxflow = 0  
  	set  @maxflow = @maxflow + 1  
  	set @vipno = '99'+ @ls_g_branch_no + right(rtrim('000000' + convert(char,@maxflow)),6)  
  	--插入会员 card_send_time  
  	insert into pos_t_vip_info (card_id,card_type,card_pwd,vip_name,vip_sex,vip_tel,card_make_flag,card_send_flag,vip_birth_date,other3,ic_cardflag,card_status,validate_flag,back_flag,oper_date,branch_no,vip_start_date,vip_end_date)  
  	values(@vipno,@ls_viptype,@pwd,@vipname,@sex,@viptel,'N','N',@vipbirth,@openid,'O',0,0,1,getdate(), @ls_g_branch_no,getdate(),dateadd(year,1,getdate()) )  
  	If @@error <> 0   
  	BEGIN  
  		set @ls_err = '插入会员系统失败!'  
  		set @vipno = ''  
  		goto rtn  
  	END  
  	--必须update一次会员信息，否则无法传到门店  
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
   SELECT f_t_employee.cEmp_C, --员工编号 
	f_t_employee.cEmp_N, --员工姓名
	f_t_employee.sSex,   --性别
	f_t_employee.dtBirth,--出生日期
	f_t_employee.dtJoin, --入职日期
	f_t_employee.cDept_C,--所属部门编号 
	f_t_employee.cDept_N,--所属部门名称 
	f_t_employee.sContact,--联系方式
	f_t_employee.sPhone,  --电话
	f_t_employee.sRemark, --备注
	f_t_employee.bServiceFlag,  --服务员标志 0-否 1-是
	f_t_employee.bSendFlag      --送餐区域
	FROM f_t_employee
	WHERE sstatus = '在职'  
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
if exists (select 1 from sysobjects where id = object_id ('wx_pr_cancelorder'))
begin
	drop procedure wx_pr_cancelorder
end 
go  
create procedure [dbo].[wx_pr_cancelorder] (@orderNo varchar(30))
as
begin 
	declare @ll_count int
	declare @ls_err varchar(500)
	declare @ll_status int
	declare @ll_rtn int --返回值：1成功，0失败
	declare @ls_paytype varchar(10) --支付状态，7为线上会员卡支付
	declare @ls_cVIP_C varchar(20) --会员卡号
	declare @nRequestAmt Numeric(12,2)  --会员消费金额
	declare @card_status	Varchar(1)	
	declare @card_balance	Numeric(12,2)	
	declare @card_preamt	Numeric(12,2)	
	declare @dBusinessdt	Datetime
	declare @flag varchar(1)
	select @ll_count = count(*) from wx_t_order_master0 where orderid = @orderNo
	If @@error <> 0
	BEGIN
		set @ls_err = '检索订单失败' 
		set @ll_rtn = 0
		goto rtn
	End
	select @ll_status = status from wx_t_order_master0 where orderid = @orderNo 
	If @@error <> 0
	BEGIN
		set @ls_err = '检索订单状态失败' 
		set @ll_rtn = 0
		goto rtn
	End
	IF @ll_status <> 10 and @ll_status > 0 --只有状态为10才允许取消
	BEGIN
		if @ll_status = '2'
			set @ls_err = '订单正在派送1，不能取消' --已下单，已打印厨单，不允许取消
		if @ll_status = '3'
			set @ls_err = '订单正在派送2，不能取消' --已派工
		if @ll_status = '5' 
			set @ls_err = '订单已经完成，不能取消' --已结账
		set @ll_rtn = 0
		goto rtn
	END
	update wx_t_order_master0 set status = -1 ,confirm_status = -1  where orderid = @orderNo
	if @@error <> 0 
	BEGIN
		set @ls_err = '更新订单状态失败' 
		set @ll_rtn = 0
		goto rtn
	END
	--从这里开始处理会员卡金额问题
	select @ls_paytype = paytype, @ls_cVIP_C = cVIP_C, @nRequestAmt = nRequestAmt from d_t_bill_pay_alipay0 where cbill_guid = @orderNo 
	If @@error <> 0
	BEGIN
		set @ls_err = '检索支付流水失败' 
		set @ll_rtn = 0
		goto rtn
	End
	if @ls_paytype = '7' and @nRequestAmt > 0 and (len(@ls_cVIP_C) > 0 or @ls_cVIP_C is not null)
	begin
		select @dBusinessdt = sys_var_value from sys_t_system where sys_var_id = 'dBusiness' 

		Select  @card_status = Isnull( pos_t_vip_info.card_status, '' ),
		@card_balance = Isnull( pos_t_vip_info.card_balance, 0 ) + @nRequestAmt,
		@flag = pos_t_vip_type.flag_1,
		@card_preamt = Isnull( pos_t_vip_info.nPreAmt, 0 ) From pos_t_vip_info 
		inner join pos_t_vip_type on pos_t_vip_info.card_type  = pos_t_vip_type.type_id
		and card_id = @ls_cVIP_C
		If @@error <> 0 Or @@rowcount <> 1
		Begin
			set @ls_err = '检索线下会员信息失败:会员卡号(' + @ls_cVIP_C + ')不存在'
			set @ll_rtn = 0
    		goto rtn 
		End
		If @card_status <> '0'
		Begin
			set @ls_err = '会员卡号(' + @ls_cVIP_C + ')线下处于非正常状态'
			set @ll_rtn = 0 
    		goto rtn 
		End	
		if @flag = '1'
		begin
			set @ls_err = '会员卡号(' + @ls_cVIP_C + ')线下为不允许储值状态'
			set @ll_rtn = 0 
    		goto rtn 
		end
		--update pos_t_vip_info SET card_balance =card_balance + @nRequestAmt,card_sbalance = dbo.fn_str_xor(CONVERT(char,card_balance + @nRequestAmt)) WHERE card_id = @ls_cVIP_C
		--If @@error <> 0
		--Begin
		--	set @ls_err = '线下登记会员卡号(' + @ls_cVIP_C + ')金额修改失败(代码' + Convert( Varchar, @@error ) + ')'
		--	set @ll_rtn = 0
		--	goto rtn 
		--End
		INSERT INTO pos_t_vip_cost ( oper_id , oper_date , card_id , card_cost , card_way , branch_no , actual_payamt , reverse_desc ,
				 dBusinessdt , bflag , cshift_n , card_balance , PreAmt , cbill_c, cPay_C  , Num_flag ) 
       		VALUES ('0000', Getdate(), @ls_cVIP_C, @nRequestAmt, '消费' , '00' , @nRequestAmt , '微信订单' ,
		@dBusinessdt , 1 , '' , @card_balance , @card_preamt , @orderNo , ''  , -1)      
		If @@error <> 0
		Begin
			set @ls_err = '线下登记会员卡号(' + @ls_cVIP_C + ')业务操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
			set @ll_rtn = -1 
    		goto rtn 
		End
	end

	set @ll_rtn = 1

	RTN:
	If len(@ls_err) > 0 or @ls_err is not null
		raiserror(@ls_err,16,1)
	select @ll_rtn
end
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
		Select @err_msg = '数据参数(card_id)空值异常'
		Goto L_ERR
	End
	If Isnull( @add_integral, 0 ) = 0
	Begin
		Select @err_msg = '数据参数(add_integral)取值异常'
		Goto L_ERR
	End
	If Isnull( @add_integral, 0 ) > 0
	Begin
		Select @type = '增加积分'
		select @mode = '+'
	End
	If Isnull( @add_integral, 0 ) < 0
	Begin
		Select @type = '减少积分'
		select @mode = '-'
		select @add_integral = @add_integral * -1
	End
	
	Select @card_status = Isnull( card_status, '' ), @sum_saleamt = Isnull( vip_cons_amount, 0 ), @sum_integral = Isnull( total_integral, 0 ) 
	From pos_t_vip_info Where card_id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '检索线下会员信息失败:会员卡号(' + @card_id + ')不存在'
		Goto L_ERR
	End
	If @card_status <> '0'
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')线下处于非正常状态'
		Goto L_ERR
	End
	if @sum_integral < @add_integral and @mode = '-'
	begin
		Select @err_msg = '会员卡号(' + @card_id + ')的积分少于即将被扣的积分'
		Goto L_ERR
	end
	
	Select @branch_no = Left( sys_var_value, 4 ) From sys_t_system Where sys_var_id = 'g_branch_no'
	
	Begin Tran T1
	
	Insert Into pos_t_integral_operating (card_id, oper_type, oper_date, oper_id, oper_descript, 
		sum_saleamt, sum_integral, reduce_amt, reduce_integral, memo, other1, branch_no) 
	Values (@card_id, @mode, Getdate(), '0000', @type+'[' + Convert( Varchar, Convert( Int, @add_integral ) ) + ']--会员[' + @card_id + ']', 
		@sum_saleamt, @sum_integral, 0, @add_integral, '手工加减', '', @branch_no)
	If @@error <> 0
	Begin
		Select @err_msg = '线下登记会员卡号(' + @card_id + ')积分操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
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
				@ll_rtn         int  --返回值：1成功，0失败  
	If Isnull( @card_id, '' ) = ''
	Begin
		Select @err_msg = '数据参数(card_id)空值异常'
		set @ll_rtn = -1 
		Goto L_ERR
	End
	If Isnull( @add_integral, 0 ) = 0
	Begin
		Select @err_msg = '数据参数(add_integral)取值异常'
		set @ll_rtn = -1 
		Goto L_ERR
	End
		
	Select @card_status = Isnull( card_status, '' ), @sum_integral = Isnull( total_integral, 0 ) 
	From pos_t_vip_info Where card_id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '检索线下会员信息失败:会员卡号(' + @card_id + ')不存在'
		set @ll_rtn = -1 
		Goto L_ERR
	End
	If @card_status <> '0'
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')线下处于非正常状态'
		set @ll_rtn = -1 
		Goto L_ERR
	End
	If Isnull( @add_integral, 0 ) < 0
	Begin
		select @add_integral = @add_integral * -1
	End
	if @sum_integral < @add_integral
	begin
		Select @err_msg = '会员卡号(' + @card_id + ')的积分少于即将被扣的积分'
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
 	orderid as 'OnLineOrderID', 
 	'' as 'WXSheetNo', 
 	paytype as 'PayType' 
  	from d_t_bill_pay_alipay0 left join d_t_food_bill0 with(nolock) on d_t_bill_pay_alipay0.cbill_c = d_t_food_bill0.cbill_c
 where d_t_bill_pay_alipay0.cbill_guid = @SheetNo 
 End
 go

 --根据会员卡号，原密码， 修改密码
--参数：会员卡号、原密码、新密码
--exec kmmicro_Pr_alter_vip_pw '0100002', '', '翁淌嗜'
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_alter_vip_pw'))
begin
	drop procedure kmmicro_Pr_alter_vip_pw
end 
go

create procedure kmmicro_Pr_alter_vip_pw(
	@cardid varchar(20),          --会员卡号
	@oldpw varchar(6),     --原密码
	@newpw varchar(6)      --新密码
)
as
begin 
	declare	@card_pw		varchar(6),
	        @ll_count		int,
	        @ls_err         varchar(500),     --错误信息
			@ll_rtn         int,              --返回值：1成功，0失败  
			@computer		varchar(50)		--计算机名
	
	select @computer = hostname from master.dbo.sysprocesses where spid=@@spid
	
	select @ll_count = count(1) from pos_t_vip_info where card_id = @cardid;
	
	if @ll_count < 1
	begin
		set @ls_err = '会员卡号不存在'
		set @ll_rtn = -1 
    	goto rtn 
	end
	
	if @oldpw = @newpw
	begin
		set @ls_err = '新密码和原密码不能相同'
		set @ll_rtn = -1 
    	goto rtn 
	end
	
	select @card_pw = card_pwd from pos_t_vip_info where card_id = @cardid
	
	if @card_pw is not null or @oldpw <> ''
	begin
		if @card_pw <> @oldpw
		begin
			set @ls_err = '原密码错误'
			set @ll_rtn = -1 
    		goto rtn 
		end
	end
	
	update pos_t_vip_info set card_pwd = @newpw where card_id = @cardid
	
	--写修改会员密码日志
	insert into sa_t_operate_log ( oper_id, oper_sys, oper_time,fun_id,fun_name,oper_str,bill_type,bill_no,oper_remark,oper_computer)
	values ('0000','09',getdate(),'线上修改密码','更改卡密码','会员更改卡密','','','微信助手修改会员密码:原密码[' + @oldpw + '],新密码[' + @newpw + ']',@computer)
	
	rtn:
   	If len(@ls_err) > 0 or @ls_err  is not null   
    	raiserror(@ls_err,16,1)  
    	select @ll_rtn   
end
go


--会员卡绑定微信号
--参数：会员卡号或者手机号、密码、微信号
if exists (select 1 from sysobjects where id = object_id ('wx_pr_checkVIP'))
begin
	drop procedure wx_pr_checkVIP
end 
go

create procedure wx_pr_checkVIP (@as_vipno char(20),@as_pwd char(6),@openid varchar(30)) --密码是加密后的密码 @openid:微信号   
    as    
    Begin    
    	declare @ll_count int    
  	declare @ls_cardid varchar(30)  
  	declare @ls_pwd varchar(30)  
  	declare @ls_operid varchar(30)  
 	declare @ls_icflag varchar(1) 
    	select @ll_count = Count(*) from pos_t_vip_info where card_id = @as_vipno    
   	If @@error <> 0      
    	BEGIN    
    		raiserror('检索会员失败!',16,1)    
    		set @ll_count = 0    
  		set @ls_cardid = ''  
    		goto rtn    
    	END    
   	If @ll_count = 0  --未检索到卡号，这检索有没有对应的手机号  
   	BEGIN   
  		select @ll_count = Count(*) from pos_t_vip_info where isnull(vip_tel,'') = @as_vipno    
   		If @@error <> 0      
  		BEGIN    
  	  		raiserror('检索会员失败!',16,1)    
  	  		set @ll_count = 0    
  			set @ls_cardid = ''  
  	  		goto rtn    
  	  	END    
  		IF @ll_count = 1 --有手机号对应，并且唯一  
  		BEGIN  
  			select @ls_cardid = card_id ,@ls_pwd = isnull(card_pwd,'') ,@ls_operid = isnull(other3,'') ,@ls_icflag = ic_cardflag from pos_t_vip_info where isnull(vip_tel,'') = @as_vipno     
  			If @@error <> 0      
  			BEGIN    
  		  		raiserror('检索会员失败!',16,1)    
  		  		set @ll_count = 0    
  				set @ls_cardid = ''  
  		  		goto rtn    
  		  	END    
  			goto checked  
  		END    
    		IF @ll_count > 1 --一个手机号对应多个会员卡 返回2  
  		BEGIN  
  			--raiserror('输入的手机号对应多个卡号，请输入卡号绑定!',16,1)    
  			set @ll_count = 2   
  			set @ls_cardid = ''  
  		  	goto rtn    
  		END   
  		IF @ll_count <= 0 --既没有会员卡对应，也没有手机号对应  
  		BEGIN  
  			raiserror('未检索到符合条件的会员，请重新输入!',16,1)    
  	  		set @ll_count = 0   
  			set @ls_cardid = ''   
  	  		goto rtn    
  		END  
   	END   
  	ELSE --有卡号对应  
  	BEGIN  
  		select @ls_cardid = card_id ,@ls_pwd = isnull(card_pwd,'')  ,@ls_operid = isnull(other3,''),@ls_icflag = ic_cardflag from pos_t_vip_info where card_id = @as_vipno    
  		If @@error <> 0      
  		BEGIN    
  	  		raiserror('检索会员失败!',16,1)    
  	  		set @ll_count = 0    
  			set @ls_cardid = '0'  
  	  		goto rtn    
  	  	END    
  		goto checked  
  	END	  
   	--更新微信号  
  	checked:   
 	--检查是否是IC卡 
 	If @ls_icflag = 'I'  
 	BEGIN 
 		raiserror('IC卡不支持绑定为微信会员卡!',16,1)    
  		set @ll_count = 0    
  		set @ls_cardid = ''  
    		goto rtn    
 	END 
  	--检查是否已被别的微信绑定  
  	If @ls_operid <> @openid  and rtrim(ltrim(@ls_operid)) <> ''  
  	BEGIN  
  		raiserror('该会员已被另一个微信账号绑定，不允许再绑定!',16,1)    
  		set @ll_count = 0    
  		set @ls_cardid = ''  
    		goto rtn    
  	END  
  	--检查密码是否正确  
  	If @ls_pwd  = @as_pwd   
  	BEGIN  
  		goto banding  
  	END  
  	ELSE  
  	BEGIN  
  		raiserror('密码错误，请重新输入!',16,1)    
  		set @ll_count = 0    
  		set @ls_cardid = ''  
    		goto rtn    
  	END  
  	banding:  
   	update pos_t_vip_info set other3 = @openid where  card_id = @ls_cardid and isnull(card_pwd,'') = @ls_pwd    
   	rtn:   
    	select  convert(char(1),@ll_count)+ @ls_cardid     
    End 

go  


--会员消费过程
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_d_vippay'))
begin
	drop procedure kmmicro_Pr_d_vippay
end 
go

create Procedure kmmicro_Pr_d_vippay( 
	@card_id	Varchar(20),			--会员卡号
	@trans_amt	Numeric(12,2),			--刷卡金额
	@branch_no	Varchar(4),				--订单分配门店号
	@order_no	Varchar(30),			--微信订单号
	@err_msg	Varchar(255) Output	--返回错误信息
) 
As 
Begin
	Declare	@vip_name		Varchar(30),
				@card_status	Varchar(1),
				@card_balance	Numeric(12,2),
				@card_preamt	Numeric(12,2),
				@dBusinessdt	Datetime,
				@ls_flagic      varchar(1)
	
	If Isnull( @card_id, '' ) = ''
	Begin
		Select @err_msg = '数据参数(card_id)空值异常'
		Return -1
	End
	If Isnull( @trans_amt, 0 ) = 0
	Begin
		Select @err_msg = '数据参数(trans_amt)取值异常'
		Return -1
	End
	If Isnull( @order_no, '' ) = ''
	Begin
		Select @err_msg = '数据参数(order_no)空值异常'
		Return -1
	End
	
	If Isnull( @branch_no, '' ) = ''
		Select @branch_no = Left( sys_var_value, 4 ) From sys_t_system Where sys_var_id = 'g_branch_no'
	
	Select @vip_name = Isnull( vip_name, '' ), @card_status = Isnull( card_status, '' ), @card_balance = Isnull( card_balance, 0 ), @ls_flagic =  ic_cardflag 
	From pos_t_vip_info Where card_id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '检索线下会员信息失败:会员卡号(' + @card_id + ')不存在'
		Return -1
	End
	If @card_status <> '0'
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')线下处于非正常状态'
		Return -1
	End

	If @ls_flagic = 'I'
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')为IC卡，不支持线上消费'
		Return -1
	End
	
	If @trans_amt > 0 And @card_balance < @trans_amt
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')线下的储值余额不足(差额' + Convert( Varchar, @trans_amt - @card_balance ) + ' 元)'
		Return -1
	End
	
	Begin Tran T1
	
	If Not Exists ( Select 1 From pos_t_vip_cost Where card_id = @card_id And card_way = '消费' And Charindex( '微信订单号:' + @order_no, reverse_desc ) > 0 )
	Begin
		Select @dBusinessdt = Convert( Datetime, Getdate() )
		Select @card_balance = Isnull( card_balance, 0 ) - @trans_amt, @card_preamt = Isnull( nPreAmt, 0 ) From pos_t_vip_info Where card_id = @card_id
		Insert Into pos_t_vip_cost (oper_id, oper_date, card_id, card_cost, card_way, reverse_desc, actual_payamt, branch_no, 
				dBusinessdt, bflag, cshift_n, card_balance, PreAmt, cbill_c, cPay_C, Num_flag) 
		Values ('0000', Getdate(), @card_id, -@trans_amt, '消费', '微信订单', -@trans_amt, @branch_no, 
			@dBusinessdt, 1, '', @card_balance, @card_preamt, @order_no, '', -1)
		If @@error <> 0
		Begin
			Select @err_msg = '线下登记会员卡号(' + @card_id + ')业务操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
			Goto L_ERR
		End
	End
	
	Commit Tran T1
	Select @err_msg = ''
	Return 0
	
L_ERR:
	Rollback Tran T1
	Return -1


End


go