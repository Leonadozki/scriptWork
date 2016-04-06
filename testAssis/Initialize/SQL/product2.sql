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
--1、增加表begin---------------------------------------------------------

--微信订单主表
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_order_master'))
begin
	CREATE TABLE[dbo].[kmmicro_t_order_master](
		[Sheet_No][varchar](32)NOT NULL,
		[BranchNo][varchar](20)NOT NULL,
		[Amount][numeric](14, 2)NOT NULL,
		[OpenId][varchar](32)NOT NULL,
		[PayFlag][char](1)NOT NULL,
		[PayWay][char](2)NOT NULL,
		[DeliveryMode][char](1)NOT NULL,
		[Linkman][varchar](20)NULL,
		[ContactTel][varchar](15)NULL,
		[Address][varchar](100)NULL,
		[CreateDate][datetime]NOT NULL,
		[Status][char](1)NOT NULL,
		[Memo][varchar](255)NULL,
		[DeliveryDate][datetime]NULL,
		[CardId][varchar](20)NULL,
		[flow_no][varchar](14)NULL,
		[send_man][char](4)NULL,
		[PayMent] char(1) default '0' not null,
	CONSTRAINT[PK_kmmicro_t_order_master]PRIMARY KEY CLUSTERED
	(
		[Sheet_No]ASC
	)
	)
end 
go

--微信订单明细表
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_order_detail'))
begin
	CREATE TABLE[dbo].[kmmicro_t_order_detail](
		[FlowId][numeric](16, 0)IDENTITY(1,1)NOT NULL,
		[Sheet_No][varchar](32)NOT NULL,
		[Sequence][int]NOT NULL,
		[ItemNo][varchar](20)NOT NULL,
		[SaleQty][numeric](12, 4)NOT NULL,
		[SalePrice][numeric](12, 4)NOT NULL,
		[SaleAmt][numeric](12, 4)NOT NULL,
		[Memo][varchar](255)NULL,
	CONSTRAINT[PK_kmmicro_t_order_detail]PRIMARY KEY NONCLUSTERED
	(
		[FlowId]ASC
	)
	)
	end 
go

--微信订单付款信息表
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_pos_t_payflow_pre'))
begin
	CREATE TABLE kmmicro_pos_t_payflow_pre (
		[sheet_no] [varchar] (32)  NOT NULL , -- 流水号
		[flow_id] [int]  NOT NULL ,
		[pay_amount] [numeric](9, 2) NULL ,-- 付款金额
		[pay_way] [char](1)  not null ,-- 付款方式
		[coin_no] [varchar] (3)  NULL ,--币种
		[card_no] [varchar] (20)  NULL ,--卡号
		[sell_way] [varchar] (1)  NULL ,-- 销售方式  
		CONSTRAINT [pk_kmmicro_pos_t_payflow_pre] PRIMARY KEY  CLUSTERED 
		(
			[sheet_no],
			[flow_id]
		) 
	) 
end 
go

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

--上传时间表
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_trans_time'))
begin
	CREATE TABLE[dbo].[kmmicro_t_trans_time](
		[type][varchar](50)NOT NULL,
		[up_time][datetime]NULL
	)
end 
go

--微信付款流水表
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_paymentFlow'))
begin
	CREATE TABLE[dbo].[kmmicro_t_paymentFlow](
		[SheetNo][varchar](32)NOT NULL,
		[BranchNo][varchar](20)NOT NULL,
		[Amount][numeric](14, 2)NOT NULL,
		[Status][char](1) default '0'NOT NULL,
		[PayStatus][char](1)NOT NULL,
		[CreateDate][datetime]NOT NULL,
		[PayDate][datetime]NULL,
		[DeliveryMan][varchar](40)NULL,
		WXSheetNo varchar(32) null,
	CONSTRAINT[pk_kmmicro_t_paymentFlow]PRIMARY KEY CLUSTERED
	(
		[SheetNo]ASC
	)
	)
end 
go
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='kmmicro_t_paymentFlow' and syscolumns.name ='PayWay')
begin
	alter table kmmicro_t_paymentFlow add PayWay varchar(10) null
end
go
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='kmmicro_t_paymentFlow' and syscolumns.name ='cardno')
begin
	alter table kmmicro_t_paymentFlow add cardno varchar(50) null
end
go
--增加表end-----------------------------------------------------------

--3、增加存储过程begin---------------------------------------------------------
--1存储过程名：kmmicro_Pr_get_cashno，参数：无
--用途：用于通讯助手登录时获取到线下的收银机号
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_cashno'))
begin
	drop procedure kmmicro_Pr_get_cashno
end 
go
create procedure kmmicro_Pr_get_cashno
as
begin
	select '00' as cash_no
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
	select item_clsno as ClsNo,item_clsname as ClsName,parent_no as ParentNo from kmmicro_t_item_cls
end
go

--3存储过程名：kmmicro_pr_get_pos_flowno，参数：@cash_no收银机号 @oper_date时间 @branch_id 仓库
--                                          返回值：单号，当班日期
--用途：用于通讯助手类别维护时查询已新增的类别
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_pos_flowno'))
begin
	drop procedure kmmicro_pr_get_pos_flowno
end 
go
create  procedure kmmicro_pr_get_pos_flowno(@cash_no varchar(3),
                                      @oper_date varchar(30),
                                      @branch_no varchar(20),
                                      @flow_no  varchar(20) output,
                                      @trade_date varchar(8) output)
as
begin
    declare @max_flow_no varchar(20),
            @len_branch_id int,
            @branch_flow    varchar(4),
            @date_flow     varchar(8)

    select @date_flow=left(@oper_date,4)+substring(@oper_date,6,2)+substring(@oper_date,9,2)

    select @max_flow_no=max(right(flow_no,4)) 
    from pos_t_saleflow
    where branch_no=@branch_no 
          and left(flow_no,2)=@cash_no

    select @max_flow_no=@max_flow_no + 1
    if @max_flow_no is null or @max_flow_no=''  set @max_flow_no='1'

    select @max_flow_no=replicate('0',4 - len(@max_flow_no))+str(@max_flow_no,len(@max_flow_no))
    select @flow_no=@cash_no+@date_flow+@max_flow_no,
           @trade_date=@date_flow
  end
go
  
--4存储过程名：kmmicro_pr_get_batch，参数：@oper_date时间
--                                          返回值：@batch_no班次
--用途：用于获取班次
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_batch'))
begin
	drop procedure kmmicro_pr_get_batch
end 
go
create  procedure kmmicro_pr_get_batch (@oper_date varchar(30),@batch_no varchar(1) output)
as
begin

   declare @batch_list     varchar(30),
           @batch_1        varchar(5),
           @batch_2        varchar(5),
           @batch_3        varchar(5),
           @batch_4        varchar(5),
           @batch          varchar(5)


   select @batch=substring(@oper_date,12,5)

   select @batch_list=ltrim(rtrim(sys_var_value)) from sys_t_system where sys_var_id='pos_batch_time'

   select @batch_1=left(@batch_list,5),@batch_2=substring(@batch_list,6,5),@batch_3=substring(@batch_list,11,5),@batch_4=right(@batch_list,5)

   if @batch_4='00:00' 
   begin
	   if exists (select 1 from sysobjects where @batch between @batch_1 and @batch_2)
	   begin
	      set @batch_no='A'
	   end
	   else if exists (select 1 from sysobjects where @batch between @batch_2 and @batch_3)
	   begin
	      set @batch_no='B'
	   end
	   else if exists (select 1 from sysobjects where @batch between @batch_3 and @batch_4)
	   begin
	      set @batch_no='C'
	   end
	   else
	   begin
	      set @batch_no='A'
	   end
   end
   else
   begin
	   if exists (select 1 from sysobjects where @batch between @batch_1 and @batch_2)
	   begin
	      set @batch_no='A'
	   end
	   else if exists (select 1 from sysobjects where @batch between @batch_2 and @batch_3)
	   begin
	      set @batch_no='B'
	   end
	   else if exists (select 1 from sysobjects where @batch between @batch_3 and @batch_4)
	   begin
	      set @batch_no='C'
	   end
	   else
	   begin
	      set @batch_no='D'
	   end
   end
end
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

	select  identity(int) id,item_no ItemNo,item_name ItemName,unit_no ItemUnit,item_size ItemSize,sale_price Price ,bi_t_item_cls.item_clsname Brand,product_area  Origin ,' ' ProductionDate,valid_days ShelfLife ,unit_no Packaging,item_size Size
	into #temp
	from bi_t_item_info left join bi_t_item_cls on (bi_t_item_info.item_brand = bi_t_item_cls.item_clsno and bi_t_item_cls.item_flag = '1')
	where bi_t_item_info.item_clsno like @clsno+'%' and  (item_no like '%'+@keyword+'%' or item_name like '%'+@keyword+'%') 
	--总记录数.
	select @TotalSize=max(id) from #temp 
	--分页查询.
	select * from #temp where id between @StartRow and @EndRow
	--释放临时表.
	drop table #temp
	
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
	select item_no as ItemNo,item_name as ItemName,item_clsno as ItemClsNo,unit_no as ItemUnit,item_size as ItemSize,sale_price as Price from bi_t_item_info where item_no=@item_no order by item_no asc
end
go


--8存储过程名：kmmicro_Pr_set_payflow_pre，参数：@SheetNo单号，@Flowid序号，@payamount付款金额，@payway付款方式，@coinno币种，@cardno卡号，@sellway销售方式
--用途：用于写订单付款表
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_payflow_pre'))
begin
	drop procedure kmmicro_Pr_set_payflow_pre
end 
go
create procedure kmmicro_Pr_set_payflow_pre(@SheetNo varchar(32),
	@Flowid int,
	@payamount numeric(12,2),
	@payway varchar(1),
	@coinno varchar(3),
	@cardno varchar(20),
	@sellway varchar(1))

as
begin
	if exists (select 1 from kmmicro_pos_t_payflow_pre where sheet_no = @SheetNo)
		delete from kmmicro_pos_t_payflow_pre  where sheet_no = @SheetNo

	insert into kmmicro_pos_t_payflow_pre(Sheet_No,flow_id,pay_amount,pay_way,coin_no,card_no,sell_way)
	values(@SheetNo,@Flowid,@payamount,@payway,@coinno,@cardno,@sellway)
end
go


--9存储过程名：kmmicro_pr_get_wxflowno，参数：@brach_no仓库，@oper_date日期
--用途：用于获取微信付款单号
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_wxflowno'))
begin
	drop procedure kmmicro_pr_get_wxflowno
end 
go
create procedure kmmicro_pr_get_wxflowno(@brach_no varchar(10),@oper_date varchar(10))
as
Begin
	declare @ll_count int,
		    @ls_maxflow varchar(100)
	select @ls_maxflow=MAX(SheetNo)from kmmicro_t_paymentFlow where SUBSTRING(SheetNo,1,2)='wx' and BranchNo =@brach_no
		if @ls_maxflow is null
			set @ll_count=1
		else
			begin
				if CONVERT(varchar(10),GETDATE(),112)=@oper_date
					set @ll_count=convert(int,RIGHT(@ls_maxflow,4))+1
				else	
					set @ll_count=1
			end
	select @ll_count as count
End
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
	declare @clsset varchar(50)
	declare @noCount int
	declare @index int
	--创建分类临时表.
	create table #clsTemp(
		clsno varchar(50)null,			--分类编码.
		clsname varchar(50)null,		--分类名称.
		parentno varchar(50)null		--上级编码.
	)
	--查询分类编码规则.
	select @clsset=sys_var_value+'-' from sys_t_system where sys_var_id='item_cls_level'
	set @index=charindex('-',@clsset)
	set @noCount= 0
	--循环把分类数据写入临时表.
	while(@index!=0 )
	begin
		set @noCount = @noCount + SUBSTRING(@clsset,0,@index)
		set @clsset=SUBSTRING(@clsset,@index+1,50)
		insert into #clsTemp
		select item_clsno clsno,item_clsname clsname,SUBSTRING(item_clsno,0,@noCount-1) parentno
		from bi_t_item_cls
		where Len(item_clsno)=@noCount and item_flag = '0'
		order by clsno
		set @index=charindex('-',@clsset)
	end
	--查询的结果.
	if @parent_clsno = '0'
		select * from #clsTemp 
	else
		select * from #clsTemp where ParentNo = @parent_clsno
	--临时表释放.
	drop table #clsTemp
	
End
go


--11存储过程名：kmmicro_pr_checkserverman，参数：@as_serverman送货员ID
--用途：用于线上绑定送货员验证
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_checkserverman'))
begin
	drop procedure kmmicro_pr_checkserverman
end 
go
create procedure kmmicro_pr_checkserverman(@as_serverman varchar(12))
as
Begin
	declare @ll_count int,
		@ls_result varchar(100)
		select @ls_result='success'
	select @ll_count=Count(*) from pos_t_cler_info where cler_no=@as_serverman
		if @ll_count<=0
		begin
			select @ls_result='员工'+@as_serverman+'不存在'
		end
	select @ll_count as result,@ls_result as msg
End
go

--12存储过程名：kmmicro_pr_checkserverman，参数：
--用途：用于线上写操作日志
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_trans_log'))
begin
	drop procedure kmmicro_pr_trans_log
end 
go
create procedure kmmicro_pr_trans_log(@as_fun char(1),@as_type char(1),@as_msgc varchar(4000),@adt_time datetime,@as_flag varchar(1))
as
begin
	insert into kmmicro_t_trans_log(fun,type,msgc,oper_date,flag)values (@as_fun,@as_type,@as_msgc,@adt_time,@as_flag)
end
go



--13存储过程名：kmmicro_Pr_set_WXPaymentFlow 参数： @SheetNo单号，@PayStatus状态，@PayDate付款时间
--用途：用于更改微信支付流水的付款状态

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_WXPaymentFlow'))
begin
	drop procedure kmmicro_Pr_set_WXPaymentFlow
end 
go
create procedure [dbo].[kmmicro_Pr_set_WXPaymentFlow](@SheetNo varchar(50),@PayStatus char(1),@PayDate smalldatetime,@paytype varchar(5),@cVIP_C varchar(50))
as
begin
	update kmmicro_t_paymentFlow set PayStatus=@PayStatus,PayDate=@PayDate,PayWay=@paytype,CardNo =@cVIP_C where SheetNo=@SheetNo
end
go


--14存储过程名：kmmicro_Pr_set_uptime 参数： @type类型
--用途：用于上传后记录一个上传时间
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_uptime'))
begin
	drop procedure kmmicro_Pr_set_uptime
end 
go
create procedure kmmicro_Pr_set_uptime(@type varchar(50))

as
begin
	update kmmicro_t_trans_time set up_time=getdate()where type=@type
end
go


--15存储过程名：kmmicro_Pr_set_ordermaster 参数： 
--用途：用于写订单主表
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_ordermaster'))
begin
	drop procedure kmmicro_Pr_set_ordermaster
end 
go
create procedure kmmicro_Pr_set_ordermaster(@address varchar(100),
			@Amount numeric(14,2),
			@BranchNo varchar(20),
			@CardId varchar(20),
			@ContactTel varchar(15),
			@CreateDate datetime,
			@CustId int,
			@DeliveryDate datetime,
			@DeliveryMode char(1),
			@Linkman varchar(20),
			@Memo varchar(200),
			@OpenId varchar(32),
			@PayFlag char(1),
			@PayWay char(2),
			@SheetNo varchar(32),
			@Status char(1),
			@PayMent char(1))

as
begin
	if exists(select 1 from kmmicro_t_order_master where sheet_no=@SheetNo)
		update kmmicro_t_order_master set Sheet_No=@SheetNo,
						BranchNo=@BranchNo,
						Amount=@Amount,
						OpenId=@OpenId,
						PayFlag=@PayFlag,
						PayWay=@PayWay,
						DeliveryMode=@DeliveryMode,
						Linkman=@Linkman,
						ContactTel=@ContactTel,
						Address=@Address,
						CreateDate=@CreateDate,
						Status=@Status,
						Memo=@Memo,
						DeliveryDate=@DeliveryDate,
						CardId=@CardId,
						Payment=@PayMent
		where sheet_no=@SheetNo
	else
		insert into kmmicro_t_order_master(Sheet_No,BranchNo,Amount,OpenId,PayFlag,PayWay,DeliveryMode,Linkman,ContactTel,Address,CreateDate,Status,Memo,DeliveryDate,CardId,Payment)
		values(@SheetNo,@BranchNo,@Amount,@OpenId,@PayFlag,@PayWay,@DeliveryMode,@Linkman,@ContactTel,@Address,@CreateDate,@Status,@Memo,@DeliveryDate,@CardId,@PayMent)
end
go


--16存储过程名：kmmicro_Pr_set_orderdetail 参数： 
--用途：用于写订单明细表
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_orderdetail'))
begin
	drop procedure kmmicro_Pr_set_orderdetail
end 
go
create procedure kmmicro_Pr_set_orderdetail(@ItemNo varchar(20),
	@Memo varchar(255),
	@SaleAmt numeric(12,2),
	@SalePrice numeric(12,2),
	@SaleQty numeric(12,2),
	@sequence int,
	@SheetNo varchar(32))

as
begin
	insert into kmmicro_t_order_detail(Sheet_No,Sequence,ItemNo,SaleQty,SalePrice,SaleAmt,Memo)
	values(@SheetNo,@sequence,@ItemNo,@SaleQty,@SalePrice,@SaleAmt,@Memo)
end
go



--17存储过程名：kmmicro_Pr_set_itemfilename 参数： 
--用途：用于更改商品图片路径
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_itemfilename'))
begin
	drop procedure kmmicro_Pr_set_itemfilename
end 
go
create procedure kmmicro_Pr_set_itemfilename(@item_no varchar(22),@filename varchar(255))

as
begin
	update kmmicro_t_item_info set filename=@filename where item_no=@item_no
end
go


--18存储过程名：kmmicro_Pr_get_WXPaymentFlow 参数： 
--用途：获取微信订单内容
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_WXPaymentFlow'))
begin
	drop procedure kmmicro_Pr_get_WXPaymentFlow
end 
go
create procedure kmmicro_Pr_get_WXPaymentFlow(@SheetNo varchar(30))

as
begin
	select 0 as CustID,''as ProductionType,SheetNo,BranchNo,Amount,PayStatus,CreateDate,PayDate,DeliveryMan,WXSheetNo as OnLineOrderID from kmmicro_t_paymentFlow where SheetNo=@SheetNo
end
go


--19存储过程名：kmmicro_Pr_get_newitem 参数： 
--用途：获取需要上传的所有商品
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_newitem'))
begin
	drop procedure kmmicro_Pr_get_newitem
end 
go
create procedure kmmicro_Pr_get_newitem(@type varchar(50))

as
begin
	declare @modify_time datetime
	select @modify_time=up_time from kmmicro_t_trans_time where type=@type
	select item_no as ItemNo,item_name as ItemName,item_clsno as ItemClsNo,unit_no as ItemUnit,item_size as ItemSize,ItemStatus,sale_price as Price from kmmicro_t_item_info where modfiy_date>@modify_time
end
go


--20存储过程名：kmmicro_Pr_get_itemfilename 参数： 
--用途：获取商品图片路径
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

--22 取线下收银机号
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_cashier'))
begin
	drop procedure kmmicro_Pr_get_cashier
end 
go
create  procedure kmmicro_Pr_get_cashier(@oper_id varchar(20),@oper_pw varchar(40))
as 
begin 
	declare @count int
	select @count = count(*) from pos_t_cashier where cashier_id =@oper_id and cashier_pw =@oper_pw and cashier_status = '正常'
	select @count as qty
end  
go
--24

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_CheckItem_StockOrUseable'))
begin
	drop procedure kmmicro_Pr_CheckItem_StockOrUseable
end 
go
create procedure kmmicro_Pr_CheckItem_StockOrUseable(@ItemNo varchar(20),@branch_no varchar(20))
as
begin
	declare @stockqty numeric(12,2),
			@flag varchar(10),
			@xd_qty numeric(12,2),
			@qty numeric(12,2),
			@reuslt varchar(1)
	set @reuslt ='1'
	select @stockqty = v_stock_total from pos_v_stock_total where v_item_no = @ItemNo and v_branch_no =@branch_no
	select @xd_qty = sum(b.SaleQty) from kmmicro_t_order_detail b,kmmicro_t_order_master a where a.status in ('0','1') and a.sheet_no = b.sheet_no and a.branchno = @branch_no and b.itemno = @ItemNo
	set @qty = @stockqty - @xd_qty
	if @qty <=0
		set @reuslt ='0'
	select @flag = flag7 from bi_t_item_info where item_no = @ItemNo
	if @flag ='N'
	begin
		set @reuslt ='0'
		set @stockqty =0
	end 
	select  @ItemNo as item_no,@qty as stockqty ,@reuslt as flag
end
go
--25
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_onliePaymentFlow'))
begin
	drop procedure kmmicro_Pr_set_onliePaymentFlow
end 
go
create procedure kmmicro_Pr_set_onliePaymentFlow(@SheetNo varchar(32),
			@BranchNo varchar(20),
			@Amount numeric(9,2),
			@CreateDate datetime,
			@WXSheetNo varchar(32))

as
begin
	insert into kmmicro_t_paymentFlow(SheetNo,BranchNo,Amount,Status,PayStatus,CreateDate,WXSheetNo)
	values(@SheetNo,@BranchNo,@Amount,'2','0',@CreateDate,@WXSheetNo)
end

--增加存储过程end-----------------------------------------------------------
go
--会员消费记录查询  
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_getvipcost')
	DROP PROCEDURE wx_pr_getvipcost
go
 create procedure wx_pr_getvipcost (@as_vipno varchar(12),@as_from varchar(20),@as_to varchar(20)) --时间参数yyyy-mm-dd
 as 
 Begin 
 	select distinct bi_t_branch_info.branch_no, --门店编码
		bi_t_branch_info.branch_name, --门店名称
		convert(char(10),pos_t_payflow.oper_date,120) as oper_date,--消费时间 
 		pos_t_payflow.pay_amount as card_cost , --消费金额
 		pos_t_payflow.flow_no as cbill_c --单号                     chenhd
 	from pos_t_payflow , bi_t_branch_info
 	where pos_t_payflow.branch_no = bi_t_branch_info.branch_no and pos_t_payflow.vip_no = @as_vipno and  pay_way = 'D'  and  
 	      convert(char(10),pos_t_payflow.oper_date,120) between @as_from and @as_to 
 End  
go

--积分流水查询
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_getvipintegral')
	DROP PROCEDURE wx_pr_getvipintegral
go
 create procedure wx_pr_getvipintegral (@as_vipno varchar(12),@as_from varchar(20),@as_to varchar(20)) 
 as  
 begin 
 	select branch.branch_no,  --门店编码
 		branch.branch_name, --门店名称
 		convert(char(10),oper_date,120) as oper_date, --日期 
 		reduce_integral * (case  oper_type when '+' then 1 else -1 end ) reduce_integral , --积分
 		oper_descript --操作描述 ，如消费100元，几分增加10分
 	 from pos_t_integral_operating integral,bi_t_branch_info branch 
 	where integral.branch_no = branch.branch_no and reduce_integral <> 0  
 	and  integral.card_id = @as_vipno 
 	and convert(char(10),oper_date,120)  between @as_from and @as_to  
 	order by oper_date 
 end 
go
/*会员绑定  （餐饮这边会员绑定和注册后会把对应的微信的openid记录到other3中，以控制一个微信号不能重复绑定和注册会员）
*返回值：结果标志（1位） + 卡号 
*结果标志：0：表示系统没有找到对应的卡号或手机号，1：成功，2：同一个手机号对应多个会员卡号
*/
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_checkVIP')
	DROP PROCEDURE wx_pr_checkVIP
go
 create procedure wx_pr_checkVIP (@as_vipno char(20),@as_pwd char(6),@openid varchar(30)) --密码是加密后的密码 @openid:微信号
 as 
 Begin 
 	declare @ll_count int 
 	declare @ls_cardid varchar(30)
 	declare @ls_pwd varchar(30)
 	declare @ls_operid varchar(30)
 	declare @ic_cardflag varchar(5)

 	select @ll_count = Count(*) from pos_t_vip_info where card_id = @as_vipno 
	If @@error <> 0   
	 	BEGIN 
	 		raiserror('检索会员失败!',16,1) 
	 		set @ll_count = 0 
	      set @ls_cardid = ''
	 		goto rtn 
	 	END 
	If @ll_count = 0 --未检索到卡号，这检索有没有对应的手机号
		BEGIN
	      select @ll_count = count(*) from pos_t_vip_info where isnull(vip_tel, '') = @as_vipno
	      if @@error <> 0
				BEGIN 
			 		raiserror('检索会员失败!',16,1) 
			 		set @ll_count = 0 
			      set @ls_cardid = ''
			 		goto rtn 
			 	END 
			IF @ll_count = 1 --有手机号对应，并且唯一
				BEGIN
					select @ls_cardid = card_id, @ls_pwd = isnull(card_pwd, ''), @ls_operid = isnull(other3, '') from pos_t_vip_info where isnull(vip_tel, '') = @as_vipno
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
	 		select @ls_cardid = card_id ,@ls_pwd = isnull(card_pwd,'')  ,@ls_operid = isnull(other3,'') from pos_t_vip_info where card_id = @as_vipno   
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
 	
 	select @ic_cardflag = ic_cardflag from pos_t_vip_info where card_id = @ls_cardid
 	
 	if @ic_cardflag ='I'
 	BEGIN 
 		raiserror('此会员卡是IC卡类型，不允许绑定!',16,1)
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

--获取线下员工
if  exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_employee'))
begin
   drop proc kmmicro_Pr_get_employee
end
go
create procedure kmmicro_Pr_get_employee
as
begin
  SELECT pos_t_cler_info.cler_no as cEmp_C, --员工编号 
         pos_t_cler_info.cler_name as cEmp_N --员工姓名
    FROM pos_t_cler_info  
end
go
--增加存储过程end-----------------------------------------------------------
if  not exists (select 1 from bi_t_payment_info where pay_name = '微支付')
begin
	insert bi_t_payment_info(pay_way, pay_name, pay_flag, display, pay_memo, com_branch)
	values('Z', '微支付' , '0', '1', '系统默认，不能删除', '');
end
go
if not exists (select * from sys_t_system where sys_var_id = 'wx_viptype' )
	insert into sys_t_system (sys_var_id, sys_var_name, sys_var_value, is_changed, sys_var_desc, sys_ver_flag)
	values ('wx_viptype', '微信会员', '', '1', '格式：(会员类别编码)+会员类别名称。如：（WX）微信会员', '1')
go
--增加付款方式begin
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