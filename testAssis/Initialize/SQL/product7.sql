
--微信商品表

if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_item_info'))
begin
	CREATE TABLE[dbo].[kmmicro_t_item_info](
		[item_no][varchar](13)NOT NULL,
		[item_name][varchar](40)NOT NULL,
		[item_clsno][varchar](12)NOT NULL,
		[unit_no][varchar](4)NULL,
		[sale_price][numeric](14, 4)NULL,
		[origi_price][numeric](14, 4)NULL,
		[Item_Size][varchar](20)NULL,
		[filename][varchar](255)NULL,
		[modfiy_date][datetime]NULL,
		[itemstatus][char](1)NOT NULL,
	CONSTRAINT[PK_kmmicro_t_item_info]PRIMARY KEY NONCLUSTERED
	(
		[item_no]ASC
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

--22 操作员登录 
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


--21存储过程名：kmmicro_Pr_get_clsiteminfo 参数： 
--用途：获取商品
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_clsiteminfo'))
begin
	drop procedure kmmicro_Pr_get_clsiteminfo
end 
go
create procedure kmmicro_Pr_get_clsiteminfo(@item_clsno varchar(20),@keyword varchar(50))

as
begin
if(@keyword is null or @keyword='')
	begin
		if(@item_clsno is null or @item_clsno='')
		begin
		select item_no as ItemNo,item_name as ItemName,item_clsno as ItemClsNo,unit_no as ItemUnit,item_size as ItemSize,ItemStatus,sale_price as Price
		from kmmicro_t_item_info
		order by item_no asc
		end
		else
		begin
		select item_no as ItemNo,item_name as ItemName,item_clsno as ItemClsNo,unit_no as ItemUnit,item_size as ItemSize,ItemStatus,sale_price as Price
		from kmmicro_t_item_info
		where item_clsno=@item_clsno order by item_no asc
		end
	end
else
	begin
		if(@item_clsno is null or @item_clsno='')
		begin
		select item_no as ItemNo,item_name as ItemName,item_clsno as ItemClsNo,unit_no as ItemUnit,item_size as ItemSize,ItemStatus,sale_price as Price
		from kmmicro_t_item_info
		where (item_no like @keyword or item_name like @keyword)order by item_no asc
		end
		else
		begin
		select item_no as ItemNo,item_name as ItemName,item_clsno as ItemClsNo,unit_no as ItemUnit,item_size as ItemSize,ItemStatus,sale_price as Price
		from kmmicro_t_item_info
		where item_clsno=@item_clsno and(item_no like @keyword or item_name like @keyword)order by item_no asc
		end
	end
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
--用途：获取商品图片路径     ----不用处理
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_itemfilename'))
begin
	drop procedure kmmicro_Pr_get_itemfilename
end 
go
create procedure kmmicro_Pr_get_itemfilename(@item_no varchar(22))

as
begin
	select filename from kmmicro_t_item_info where item_no=@item_no
end
go

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








  


--存储过程名：kmmicro_Pr_get_tabletypelist，参数：无 
--用途：获取厅楼
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_tabletypelist '))
begin
	drop procedure kmmicro_Pr_get_tabletypelist 
end 
go
create procedure kmmicro_Pr_get_tabletypelist 
as
begin   
	select cFloor_C as clsno, cFloor_N as clsname,'' as parentno  from f_t_floor
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
set @paytype = isnull(@paytype,'5') 
update d_t_bill_pay_alipay0 set result = @PayStatus, responseTime = @PayDate, paytype = @paytype,cVIP_C = @cVIP_C where cbill_guid = @SheetNo
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
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='pos_t_vip_cost' and syscolumns.name ='num_flag')
begin
	alter table pos_t_vip_cost add num_flag int
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
 	set @ls_msg = '微信订单服务未开启,请确认' 
 	goto rtn 
 	end 
	select top 1 @ls_tableno = cTable_C from f_t_table where cTable_N = @as_table and  bEnabled = 1   
end
else
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
select  bi_t_branch_info.branch_no, bi_t_branch_info.branch_name, convert(char(16),pos_t_vip_cost.oper_date,120) as oper_date,--消费时间 
	pos_t_vip_cost.card_cost, --消费金额
	pos_t_vip_cost.cbill_c --单号
from pos_t_vip_cost , bi_t_branch_info  
where pos_t_vip_cost.branch_no = bi_t_branch_info.branch_no and   pos_t_vip_cost.card_id = @as_vipno and  card_way = '消费'  and  
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