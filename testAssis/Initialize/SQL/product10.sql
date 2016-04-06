--1、增加表begin---------------------------------------------------------
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
--微信商品类别表
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_item_cls'))
begin
	CREATE TABLE[dbo].[kmmicro_t_item_cls](
		[item_clsno] [varchar](15)NOT NULL,
		[item_clsname] [varchar](40)NOT NULL,
		[Parent_No] [varchar](15) NULL,
		[Sort] [numeric](16, 4) default '0' NOT NULL,
		[Status] [char](1) default '1' NOT NULL,
	CONSTRAINT[PK_kmmicro_t_item_cls]PRIMARY KEY CLUSTERED
	(
		[item_clsno]ASC
	)
	)
end 
go
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
if not exists (select 1 from sysobjects where id = object_id ('wx_t_ticket_transseq'))
begin
	create table wx_t_ticket_transseq 
		 ( 
	 		seqid varchar(32) not null,		--事务流水号(GUID) 
	 		seqtype int not null,				--事务流水类型 1-用券 
	 		returncode varchar(20) not null,	--返回代码 
	 		ticketno varchar(20) not null,	--券号 
	 		custid int null,						--客户编码 
	 		ticketclsno varchar(10) null,		--券类别编号 
	 		ticketclsname varchar(50) null,	--券类别名称 
	 		cardamt numeric(16,4) null,		--券面额 
	 		createdate varchar(10) null,		--券生成日期 
	 		startdate varchar(10) null,		--券生效起始日期 
	 		enddate varchar(10) null,			--券生效截止日期 
	 		status int null,						--券状态 0-未使用 1-已使用 
	 		paydate datetime null,				--券使用时间 
	 		openid varchar(50) null,			--券用户微信号 
	 		branchno varchar(4) null,			--券指定门店号 
	 		seqstatus int not null,				--事务流水状态 0-未取用 1-已取用 
	 		seqdate datetime not null default getdate(), --生成时间 
	 		giftdesc varchar(255)  null 
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

--会员充值付款流水检查
if not exists (select 1 from sysobjects where id = object_id ('kmmicro_t_vip_cost_order'))
begin
	CREATE TABLE kmmicro_t_vip_cost_order(
		order_no varchar(50) primary key,   --微信订单号
		card_id varchar(20),                --会员卡号
		oper_type varchar(10),              --操作类型：充值、扣款
		amount numeric(14, 4),              --金额
		oper_date datetime,                 --时间
		req_times int default 1             --请求次数
	)
end
go

if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='kmmicro_t_order_master' and syscolumns.name ='DeliveryFee')
begin
	alter table kmmicro_t_order_master add DeliveryFee numeric(16,2) null
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

--处理会员绑检查是否有加字段问题 LZR 2015-11-04
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='pos_t_vip_info' and syscolumns.name ='wei_cardid')
begin
	if NOT exists (select count(1) from sys_t_system where sys_var_id ='is_weicardid')
	BEGIN
		insert into sys_t_system(sys_var_id,sys_var_name,sys_var_value,is_changed,sys_var_desc,sys_ver_flag,km_sysflag)
				 values ('is_weicardid','微会员绑定标记','1','是','1.是 0.否','1','0');
	END 
end
go

--处理会员绑定资料问题 LZR 2015-11-04
if not exists (select 1 from sysobjects,syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='pos_t_vip_info' and syscolumns.name ='wei_cardid')
begin
	alter table pos_t_vip_info add wei_cardid varchar(50) null
end
go

if exists (select count(1) from sys_t_system where sys_var_id ='is_weicardid')
begin
	--关掉触发器
	alter table pos_t_vip_info disable trigger all
	--更新原有绑定过的会员卡资料
	update pos_t_vip_info set wei_cardid = other3 ,other3 ='' where ISDATE(other3) = 0 and ISNULL(other3,'') <> ''
	--打开触发器
	alter table pos_t_vip_info enable trigger all
	
	delete sys_t_system where sys_var_id ='is_weicardid';
	
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
	select machine_no as cash_no from pos_t_machine
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

--5存储过程名：[kmmicro_pr_insert_pos_sale]，参数：@flow_no微信单号，@branch_no门店号，@cash_no pos机号，@cashier_no收银员，@oper_date时间
--用途：用于写线下业务表
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_insert_pos_sale'))
begin
	drop procedure kmmicro_pr_insert_pos_sale
end 
go
create   procedure kmmicro_pr_insert_pos_sale (@flow_no 		varchar(30), -- 微信单号
                                              @branch_no 	varchar(20), -- 门店号
                                              @cash_no 		varchar(20), -- pos机号
                                              @cashier_no	varchar(20), -- 收银员编码
                                              @oper_date		datetime )   --时间
as
begin
   declare  @g_branch_no         varchar(15),
            @pda_id              varchar(2),
            @err_msg             varchar(300),
            @batch_no            varchar(1),  --班次
            @item_no             varchar(20),
            @pool_flag           varchar(1),
            @flow_no_pos         varchar(20),
            @trade_date          varchar(8),
            @flow_id             int,
            @item_subno          varchar(30),
            @sale_price          numeric(14,4),
            @sale_qty            numeric(14,4),
            @sale_money          numeric(14,4),
            @in_price            numeric(14,4),
            @sale_addmoney       numeric(14,4),
            @sup_no              varchar(8),
            @cashier_id          int,
            @memo                varchar(40),
            @ls_tmp              varchar(30),
            @li_i1               int,
            @li_i2               int,
            @ls_cardno           varchar(30),
            @ll_cardid           int,
            @sale_amount		 numeric(14,4),
			@vip_no              varchar(20)

	select @g_branch_no=sys_var_value from sys_t_system where sys_var_id='g_branch_no'

	if exists (select 1 from tempdb..sysobjects where id=OBJECT_ID('tempdb..#temp_branch_info'))
	begin
		drop table #temp_branch_info
	end
	create table #temp_branch_info(branch_no varchar(20))
	insert into #temp_branch_info(branch_no)
	
	select distinct  t2.branch_no 
	from sys_t_system t1
	inner join bi_t_branch_info t2 on(t1.sys_var_value = t2.branch_no)
	where t1.sys_var_id='g_branch_no' 
	      and t2.display_flag='1'
	 
	--获取销售主表数据
	select @memo = memo, @vip_no = cardid, @sale_addmoney = DeliveryFee
   from kmmicro_t_order_master where sheet_no = @flow_no
	
	select count(1) from #temp_branch_info where branch_no=@branch_no
	if @@rowcount<1 
	begin
		select @err_msg='小票号的交易机构['+@branch_no+']无法上传机构['+@g_branch_no+']请确定交易机构是否可用或为上传机构下属的远程pos或仓库'
		goto err
	end
        
	select @cashier_id=cashier_id from pos_t_cashier where cashier_id=@cashier_no and  cashier_status = '正常'
	if @@rowcount<>1
	begin
		select @err_msg=@cashier_no+'收银员不存在'
		goto err
	end

	set  @ls_tmp = convert(varchar(30),@oper_date,121)
	--获取班次
	exec kmmicro_pr_get_batch @ls_tmp,@batch_no output

	if not exists (select 1 from pos_t_machine where machine_no=@cash_no)
	begin 
		select @err_msg='不存在收银机号='+@cash_no 
		goto err 
	end 

   --获取小票号+
	exec kmmicro_pr_get_pos_flowno @cash_no,@ls_tmp,@branch_no,@flow_no_pos output,@trade_date output

	--生成销售流水表end
	select @li_i1=0,@li_i2=0
	
	--生成销售流水明细数据
	declare cur cursor for
	select FlowId,itemno,saleprice,saleqty,saleamt
	from kmmicro_t_order_detail
	where sheet_no = @flow_no
	open cur
	
	fetch next from cur into @flow_id,@item_no,@sale_price,@sale_qty,@sale_money
	while @@fetch_status =0
	begin
	   select @item_no=item_no ,@in_price=price,@sup_no=sup_no,@item_subno = item_subno from bi_t_item_info where item_no=@item_no
	   if @@rowcount<>1 
	   begin
	       select @err_msg=@item_no+'商品信息不存在'
	       close cur
	       deallocate cur
	       goto err
	   end

	   select @pool_flag=isnull(check_out_flag,'1') from bi_t_supcust_info where supcust_no=@sup_no
	
	   if @pool_flag is null or @pool_flag='' set @pool_flag='1'
	   select @li_i1 = @li_i1 + 1
	   insert into pos_t_saleflow ( flow_id, flow_no, branch_no, item_no, item_clsno, sup_no, source_price, sale_price, 
                                   sale_qnty, sale_money, sell_way, oper_id, sale_man, counter_no, oper_date, trade_date,
                                   batch_no, cash_no, vip_no, pool_flag, deduct_jf, jfhg_flag, item_subno, old_no,other2 ) 
	   values (@li_i1,@flow_no_pos,@branch_no,@item_no,'', '', @sale_price,@sale_price,
              @sale_qty,@sale_money,'A',@cashier_no,'9999','9999',@oper_date,@trade_date,
              @batch_no,@cash_no,@vip_no,@pool_flag,0,'',@item_subno,'1','线上消费')
	   if @@error !=0
	   begin
	        select @err_msg=@item_no+'插入商品明细失败'
	        close cur
	        deallocate cur
	        goto err
	   end
	
		fetch next from cur into @flow_id,@item_no,@sale_price,@sale_qty,@sale_money
	end
	close cur
	deallocate cur
	
	--判断是否有外送费用 LZR 2015-08-26
	if @sale_addmoney > 0
	begin
	  select @item_no=item_no ,@in_price=price,@sup_no=sup_no,@item_subno = item_subno from bi_t_item_info where item_no='9999999999999'
	  select @li_i1 = @li_i1 + 1
	  insert into pos_t_saleflow ( flow_id, flow_no, branch_no, item_no, item_clsno, sup_no, source_price, sale_price, 
                                   sale_qnty, sale_money, sell_way, oper_id, sale_man, counter_no, oper_date, trade_date,
                                   batch_no, cash_no, vip_no, pool_flag, deduct_jf, jfhg_flag, item_subno, old_no,other2 ) 
	   values (@li_i1,@flow_no_pos,@branch_no,@item_no,'', '', @sale_addmoney,@sale_addmoney,
              @sale_qty,@sale_addmoney,'A',@cashier_no,'9999','9999',@oper_date,@trade_date,
              @batch_no,@cash_no,@vip_no,@pool_flag,0,'',@item_subno,'1','线上消费')
	end 	
	--end生成销售流水

	--生成付款流水
	select @flow_id=0
	select @sale_money = sum(case sell_way when 'D' then - pay_amount else pay_amount end) from kmmicro_pos_t_payflow_pre where sheet_no = @flow_no 

	declare cur1 cursor for
	select flow_id from kmmicro_pos_t_payflow_pre where sheet_no = @flow_no
	open cur1
	fetch next from cur1 into @flow_id
	
	while @@fetch_status = 0 
	begin
	   select @li_i2=@li_i2+1
	  
	   insert into pos_t_payflow (flow_id, flow_no, sale_amount, branch_no, pay_way, sell_way, card_no, vip_no, 
                                 coin_no, coin_rate, pay_amount, oper_date, oper_id, counter_no, sale_man, 
                                 trade_date, batch_no, cash_no,other2 )  
	   select @li_i2,@flow_no_pos,@sale_money,@branch_no,pay_way = (case pay_way when 'E' then 'WX' when 'V' then 'Z' else pay_way end),sell_way,card_no,@vip_no,
             coin_no,1.0000,pay_amount,@oper_date,@cashier_no,'9999','9999',
             @trade_date,@batch_no,@cash_no ,'线上消费'
	   from   kmmicro_pos_t_payflow_pre
	   where flow_id = @flow_id  and sheet_no = @flow_no 
	   if @@error !=0
		begin
			select @err_msg='插入商品付款流水失败flow_id='+str(@flow_id)
			close cur1
			deallocate cur1
			goto err
		end
	   fetch next from cur1 into @flow_id
	end
	close cur1
	deallocate cur1
   --生成付款流水end 

	--commit tran t
	return
	   
	err:
	raiserror(@err_msg,16,1)
 	--rollback tran t
	return

end
go

--6存储过程名：[kmmicro_pr_get_itemslist]，参数：@clsno类别，@keyword模糊查询的参数
--用途：用于获取线下商品列表
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_itemslist'))
begin
	drop procedure kmmicro_pr_get_itemslist
end 
go
create procedure kmmicro_pr_get_itemslist
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

	select identity(int) id,item_no ItemNo,item_name ItemName,isnull(unit_no,'') ItemUnit,sale_price Price ,isnull(bi.item_size,'') ItemSize,
        brand.item_clsname Brand,isnull(bi.product_area,'') Origin ,' 'ProductionDate ,bi.valid_days ShelfLife  ,bi.unit_no Packaging ,isnull(bi.item_size,'') Size
     into #temp
     from bi_t_item_info as bi
        left join bi_t_item_cls as brand on(brand.item_clsno = bi.item_clsno)
     where bi.item_clsno like @clsno+'%' and  (item_no like '%'+@keyword+'%' or item_name like '%'+@keyword+'%') and brand.item_flag='0'
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
create procedure kmmicro_pr_get_clslist(@parent_clsno varchar(50))
as
Begin	
	declare @clsset varchar(50)
	declare @noCount int
	declare @noCount_pre int
	declare @index int
	--创建分类临时表
	create table #clsTemp(
		clsno varchar(50)null,			--分类编码
		clsname varchar(50)null,		--分类名称
		parentno varchar(50)null		--上级编码
	)

	select @clsset=sys_var_value+'-' from sys_t_system where sys_var_id='item_cls_level'
	set @index=charindex('-',@clsset)
	set @noCount= 0
	set @noCount_pre=0
	--循环把分类数据写入临时表
	while(@index!=0 )
	begin
		set @noCount_pre = @noCount
		set @noCount = @noCount + SUBSTRING(@clsset,0,@index)
		
		set @clsset=SUBSTRING(@clsset,@index+1,50)
		insert into #clsTemp
		select item_clsno clsno,item_clsname clsname,SUBSTRING(item_clsno,0,@noCount_pre) parentno
		from bi_t_item_cls
		where Len(item_clsno)=@noCount
		and item_flag='0'  
		order by clsno
		set @index=charindex('-',@clsset)
	end
	--查询的结果	
	
	if @parent_clsno = '0' or @parent_clsno = ''
		select * from #clsTemp 
	else
		select * from #clsTemp where ParentNo = @parent_clsno
	--临时表释放
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

create procedure [dbo].[kmmicro_Pr_set_ordermaster](@address varchar(100),
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
			@PayMent char(1),
			@DeliveryFee numeric(16,2))
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
						Payment=@PayMent,
						DeliveryFee = @DeliveryFee
		where sheet_no=@SheetNo
	else
		insert into kmmicro_t_order_master(Sheet_No,BranchNo,Amount,OpenId,PayFlag,PayWay,DeliveryMode,Linkman,ContactTel,Address,CreateDate,Status,Memo,DeliveryDate,CardId,Payment,DeliveryFee)
		values(@SheetNo,@BranchNo,@Amount,@OpenId,@PayFlag,@PayWay,@DeliveryMode,@Linkman,@ContactTel,@Address,@CreateDate,@Status,@Memo,@DeliveryDate,@CardId,@PayMent,@DeliveryFee)
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
create procedure kmmicro_Pr_get_WXPaymentFlow(@SheetNo varchar(50))

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
--会员基本资料查询 
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_getvipinfo')
begin
	DROP PROCEDURE wx_pr_getvipinfo
end
go
create procedure wx_pr_getvipinfo (@as_vipno varchar(20))  
as
Begin
	SELECT   pos_t_vip_info.card_id,   --卡号
 	        pos_t_vip_info.vip_name,   --会员名称
 	        pos_t_vip_info.vip_sex,   --性别
 	        pos_t_vip_info.vip_idno, --身份证号码
 	        pos_t_vip_info.vip_add,    --会员地址
 	        pos_t_vip_info.job_add,   --工作单位
 	        pos_t_vip_info.vip_zip,  --会员邮编
 	        pos_t_vip_info.mobile as mobile_phone,   --会员手机
 	        pos_t_vip_info.vip_tel as vip_mobile,   --会员电话        chenhd
 	        pos_t_vip_info.vip_email,   --会员邮箱
 	        pos_t_vip_info.vip_area,   --会员所属区域
 	        pos_t_vip_info.vip_vocation,   --会员所在行业
 	        pos_t_vip_info.validate_flag,   --是否起用有效期控制
 	        pos_t_vip_info.vip_start_date,   --开始有效期
 	        pos_t_vip_info.vip_end_date,   --结束有效期			CONVERT(numeric(14,2),dbo.fn_str_xor(pos_t_vip_info.card_sbalance)) as card_balance,
 	        pos_t_vip_info.vip_avocation,   --业余爱好
 	        convert(char(10),pos_t_vip_info.vip_birth_date,120) as vip_birth_date,  --阳历生日 （微信只显示阳历生日）
 	        convert(char(10),pos_t_vip_info.vip_birth2_date,120) as vip_birth2_date, --阴历生日   
 	        pos_t_vip_info.vip_earning,   --会员收入
 	        pos_t_vip_info.vip_favorbrand,   --喜欢的品牌        
 	        '' as remark,   --备注                chenhd
 	        '' as cEmp_c, --业务员               chenhd
 	        CONVERT(numeric(14,2),pos_t_vip_info.vip_cons_amount) as vip_cons_amount,   --累计消费金额
 	        pos_t_vip_info.cons_count,   --累计消费次数     
 	        CONVERT(numeric(14,2),pos_t_vip_info.vip_integral) as vip_integral,  --当前积分 
 	        CONVERT(numeric(14,2),pos_t_vip_info.total_integral) as total_integral,  --累计积分  
 	        CONVERT(numeric(14,2),pos_t_vip_info.card_amount) as card_amount,  --累计充值总额 
 	        (case pos_t_vip_info.card_status when 'N' then '未生效' when '0' then '正常' when '1' then '无效' when '2' then '挂失' when '3' then '收' else '未知' end ) card_status ,   --卡状态
 	        (select type_name from pos_t_vip_type where pos_t_vip_type.type_id = pos_t_vip_info.card_type) as type_name     --卡类别
 	FROM pos_t_vip_info  
 	WHERE pos_t_vip_info.card_id = @as_vipno 
End 
go
--会员消费记录查询  
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_getvipcost')
	DROP PROCEDURE wx_pr_getvipcost
go
 create procedure wx_pr_getvipcost (@as_vipno varchar(12),@as_from varchar(20),@as_to varchar(20)) --时间参数yyyy-mm-dd
 as 
 Begin 
    SELECT A.branch_no,A.branch_name,A.oper_date,A.card_cost,A.cbill_c 
    FROM (
			 select distinct bi_t_branch_info.branch_no, --门店编码
				bi_t_branch_info.branch_name, --门店名称
				convert(char(16),pos_t_payflow.oper_date,120) as oper_date,--消费时间 
				pos_t_payflow.pay_amount as card_cost , --消费金额
				pos_t_payflow.flow_no as cbill_c --单号                     chenhd
			from pos_t_payflow , bi_t_branch_info
			where pos_t_payflow.branch_no = bi_t_branch_info.branch_no and pos_t_payflow.card_no = @as_vipno and  
				 pay_way = 'D'  and isnull(vip_no,'')='' and convert(char(10),pos_t_payflow.oper_date,120) between @as_from and @as_to 
			union all
			select  bi_t_branch_info.branch_no, --门店编码
					bi_t_branch_info.branch_name, --门店名称
					convert(char(16),pos_t_saleflow.oper_date,120) as oper_date,--消费时间 
					sum(pos_t_saleflow.sale_money) as card_cost , --消费金额
					pos_t_saleflow.flow_no as cbill_c --单号                     chenhd
			from pos_t_saleflow , bi_t_branch_info
			where pos_t_saleflow.branch_no = bi_t_branch_info.branch_no and pos_t_saleflow.vip_no = @as_vipno and  
				  convert(char(10),pos_t_saleflow.oper_date,120) between @as_from and @as_to 
			group by bi_t_branch_info.branch_no, 
					 bi_t_branch_info.branch_name,
					 flow_no,
					 convert(char(16),pos_t_saleflow.oper_date,120)
		) AS A
	ORDER BY A.oper_date desc	  
 End  
go

--积分流水查询
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_getvipintegral')
	DROP PROCEDURE wx_pr_getvipintegral
go
 create procedure wx_pr_getvipintegral (@as_vipno varchar(12),@as_from varchar(20),@as_to varchar(20)) 
 as  
 begin 
    declare
    @ls_branch          char(6),
	@ls_branchname      varchar(100)
	
	select @ls_branch =sys_var_value from sys_t_system where sys_var_id='g_branch_no'
	select @ls_branchname = branch_name from bi_t_branch_info where branch_no = @ls_branch
 
 	select branch_no   = @ls_branch ,  --门店编码
 		   branch_name = @ls_branchname, --门店名称
 		convert(char(16),oper_date,120) as oper_date, --日期 
 		reduce_integral * (case  oper_type when '+' then 1 else -1 end ) reduce_integral , --积分
 		oper_descript --操作描述 ，如消费100元，几分增加10分  	 
 	from pos_t_integral_operating integral,bi_t_branch_info branch 
 	where integral.branch_no *= branch.branch_no and reduce_integral <> 0  
 	and  integral.card_id = @as_vipno 
	and convert(char(10),oper_date,120)  between @as_from and @as_to  
 	order by oper_date desc 
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
	declare @ic_cardflag varchar(10)
	
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
	      select @ll_count = count(*) from pos_t_vip_info where isnull(mobile, '') = @as_vipno
	      if @@error <> 0
				BEGIN 
			 		raiserror('检索会员失败!',16,1) 
			 		set @ll_count = 0 
			      set @ls_cardid = ''
			 		goto rtn 
			 	END 
			IF @ll_count = 1 --有手机号对应，并且唯一
				BEGIN
					select @ls_cardid = card_id, @ls_pwd = isnull(card_pwd, ''), @ls_operid = isnull(wei_cardid, '') from pos_t_vip_info where isnull(mobile, '') = @as_vipno
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
	 		select @ls_cardid = card_id ,@ls_pwd = isnull(card_pwd,'')  ,@ls_operid = isnull(wei_cardid,'') from pos_t_vip_info where card_id = @as_vipno   
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
  	update pos_t_vip_info set wei_cardid = @openid where  card_id = @ls_cardid and isnull(card_pwd,'') = @ls_pwd   
  	rtn:  
   	select  convert(char(1),@ll_count)+ @ls_cardid    
   End   
go
/*会员注册 会员注册需要设置微信会员的类别，否者不支持注册
*注册会员卡号生成规则 ‘99’+ 门店编码 + 6位流水

参数说明
@vipname	会员姓名
@sex		会员性别
@viptel		会员手机号
@vipbirth	会员生日
@pwd		会员密码（传入的是已加密的密码，直接存入数据库即可）
@openid		微信号

会员号生成规则 99+门店号+6位流水 
*/

if not exists (select * from sys_t_system where sys_var_id = 'wx_viptype' )
	insert into sys_t_system (sys_var_id, sys_var_name, sys_var_value, is_changed, sys_var_desc, sys_ver_flag)
	values ('wx_viptype', '微信会员', '', '1', '格式：(会员类别编码)+会员类别名称。如：（WX）微信会员', '1')
go

if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_insertvip')
	DROP PROCEDURE wx_pr_insertvip
go

-- execute wx_pr_insertvip '测试会员', '女', '13011011211', '1995-01-01', '', 'weixinhao'
 create procedure wx_pr_insertvip(@vipname varchar(30),@sex char(5),@viptel char(16),@vipbirth datetime, @pwd char(6),@openid varchar(30) ) 
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
 	 
 	select @ll_count = count(card_id) from pos_t_vip_info where isnull(wei_cardid,'') = @openid and isnull(@openid,'') <> '' 
 	if @ll_count > 0  
 	BEGIN 
 		set @ls_err = '该微信已经注册过会员，不能重复注册!' 
 		set @vipno = '' 
 		goto rtn 
 	END  

 	select  @ls_g_branch_no = sys_var_value from sys_t_system where sys_var_id = 'g_branch_no' --本门店编码	if @ls_g_branch_no is null set @ls_g_branch_no = ''
	set @ll_cardlen = len(@ls_g_branch_no) + 8
 	select  @ls_wxviptype = sys_var_value from sys_t_system where sys_var_id = 'wx_viptype' --微会员归属类
 	If @@error <> 0  
 	BEGIN 
 	

 		select top 1  @vipno  = card_id from pos_t_vip_info where isnull(wei_cardid,'') = @openid and isnull(@openid,'') <> '' 
 	
 		Update pos_t_vip_info set vip_name = @vipname,vip_sex = @sex ,vip_birth_date = @vipbirth, vip_tel = @viptel ,mobile = @viptel
  	    where card_id =  @vipno   
  	     
  		select @vipno  
  		
  		return 
 		
 		--set @ls_err = '检索会员类别记录失败!' 
 		--set @vipno = '' 
 		--goto rtn 
 	END 
 	If @ls_wxviptype = '' or @ls_wxviptype is null  
 	BEGIN 
 		set @ls_err = '本机构暂时不允许注册会员!' 
 		set @vipno = '' 
 		goto rtn  
 	END 
 	--截取会员类别 格式 原格式：（会员类别编码）会员类别名称  如（01）微会员
 	set @ls_viptype =@ls_wxviptype

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
 		set @ls_err = '系统不存在会员类别'+@ls_wxviptype+'!' 
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
 	insert into pos_t_vip_info (card_id,card_type,card_pwd,vip_name,vip_sex,mobile,card_make_flag,card_send_flag,vip_birth_date,wei_cardid,ic_cardflag,card_status,validate_flag,back_flag,oper_date,branch_no,vip_start_date,vip_end_date) 
 	values(@vipno,@ls_viptype,@pwd,@vipname,@sex,@viptel,'N','N',@vipbirth,@openid,'O',0,0,1,getdate(), @ls_g_branch_no ,getdate(),dateadd(year,1,getdate())) 
 	If @@error <> 0  
 	BEGIN 
 		set @ls_err = '注册会员失败!' 
 		set @vipno = '' 
 		goto rtn 
 	END 
   --必须update一次会员信息，否则无法传到门店  
  	Update pos_t_vip_info set vip_name = @vipname,vip_sex = @sex ,vip_birth_date = @vipbirth, vip_tel = @viptel ,mobile = @viptel
  	where card_id =  @vipno   
 	select @vipno 
 	return 
 	rtn: 
 	If len(@ls_err) > 0 or @ls_err is null 
 		raiserror(@ls_err,16,1)  
 	select @vipno 
 end 
go
if  exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_d_vippay'))
begin
   drop proc kmmicro_Pr_d_vippay
end
go
create Procedure kmmicro_Pr_d_vippay( 
	@card_id		Varchar(20),			--会员卡号
	@trans_amt	Numeric(12,2),			--刷卡金额
	@branch_no	Varchar(4),				--订单分配门店号
	@order_no	Varchar(30),			--微信订单号
	@err_msg		Varchar(255) Output	--返回错误信息
) 
As 
Begin
	Declare	@vip_name		Varchar(30),
				@card_status	Varchar(1),
				@card_balance	Numeric(12,2),
				@card_preamt	Numeric(12,2),
				@dBusinessdt	Datetime
	
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
	
	Select @vip_name = Isnull( vip_name, '' ), @card_status = Isnull( card_status, '' ), @card_balance = Isnull( card_balance, 0 ) 
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
	If @trans_amt > 0 And @card_balance < @trans_amt
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')线下的储值余额不足(差额 ' + Convert( Varchar, @trans_amt - @card_balance ) + ' 元)'
		Return -1
	End
	
	Begin Tran T1
	
	update pos_t_vip_info set card_balance = Isnull( card_balance, 0 ) - @trans_amt,card_sbalance =dbo.fn_str_xor(convert(varchar(50),Isnull( card_balance, 0 ) - @trans_amt)) Where card_id = @card_id
	If @@error <> 0
	Begin
		Select @err_msg = '线下登记会员卡号(' + @card_id + ')更新余额失败(代码' + Convert( Varchar, @@error ) + ')'
		Goto L_ERR
	End
	
	Insert Into pos_t_vip_cost (oper_id, oper_date, card_id, card_cost, card_way, reverse_desc, actual_payamt, branch_no,com_branch) 
	Values ('0000', Getdate(), @card_id, -@trans_amt, '消费', '微信订单号:' + @order_no, -@trans_amt, @branch_no,@branch_no)
	If @@error <> 0
	Begin
		Select @err_msg = '线下登记会员卡号(' + @card_id + ')业务操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
		Goto L_ERR
	End
	
	Commit Tran T1
	Select @err_msg = ''
	Return 0
	
L_ERR:
	Rollback Tran T1
	Return -1
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
if  not exists (select 1 from bi_t_payment_info where pay_way = 'Z')
begin
	insert bi_t_payment_info(pay_way, pay_name, pay_flag, display, pay_memo, com_branch)
	values('Z', '微支付' , '0', '1', '系统默认，不能删除', '');
end
go
if not exists (select * from sys_t_system where sys_var_id = 'wx_viptype' )
	insert into sys_t_system (sys_var_id, sys_var_name, sys_var_value, is_changed, sys_var_desc, sys_ver_flag)
	values ('wx_viptype', '微信会员', '', '1', '格式：(会员类别编码)+会员类别名称。如：（WX）微信会员', '1')
go
if (select sys_var_value from sys_t_system where sys_var_id = 'wx_viptype' ) ='(99)微会员'
	update sys_t_system set sys_var_value ='' where sys_var_id ='wx_viptype'
go
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_cardbalanch'))
begin
	drop procedure kmmicro_Pr_get_cardbalanch
end 
go
create  procedure kmmicro_Pr_get_cardbalanch(@vip_no varchar(20))
as
begin   
	select card_id as cardno, CONVERT(numeric(14,2),dbo.fn_str_xor(card_sbalance))  as card_balance  from pos_t_vip_info where card_id = @vip_no
end
go

--会员充值
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_fillmoney'))
begin
	drop procedure kmmicro_Pr_set_fillmoney
end 
go
create procedure kmmicro_Pr_set_fillmoney(
	@order_no varchar(50),        --微信订单号
	@vip_no varchar(20),          --会员卡号
	@fillmoney Numeric(12,2),     --充值金额
	@presentmoney Numeric(12,2)   --赠送金额
)
as
begin  
	declare @ls_err         varchar(500),     --错误信息
			@ll_rtn         int,              --返回值：1成功，0失败  
			@card_status	Varchar(1),	      --会员状态
			@card_balance	Numeric(14,4),	  --充值后余额
			@card_preamt	Numeric(14,4),	  --
			@flag			varchar(1),       --标志
			@branch_no		varchar(6),        --机构编码
			@card_balances	varchar(14),	  --明文余额
			@desc           varchar(100),
			@trade_date		varchar(8)
	
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
	
	--增加请求流水检查，避免多次写入资料
	if (select count(1) from kmmicro_t_vip_cost_order where order_no = @order_no and card_id = @vip_no) > 0
	begin
		update kmmicro_t_vip_cost_order set req_times = req_times + 1 where order_no = @order_no and card_id = @vip_no
		set @ll_rtn = 1
		goto rtn
	end
	
	
	If @presentmoney <= 0 or @presentmoney is null
		set @presentmoney = 0
	
	Select  @card_status = Isnull( pos_t_vip_info.card_status, '' ),
			@card_balance = Isnull( pos_t_vip_info.card_balance, 0 ) + @fillmoney + @presentmoney,
			@flag = pos_t_vip_type.flag_1,
			@card_preamt = dbo.fn_str_xor(case ltrim(rtrim(card_sbalance)) when '' then 'CJ;=D538CL;=' else card_sbalance end)
	From pos_t_vip_info 
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
	
	Select @branch_no = Left( sys_var_value, 4 ) From sys_t_system Where sys_var_id = 'g_branch_no'   --取得当前机构
	select @card_balance = @fillmoney + @presentmoney + convert(decimal(14,4), dbo.fn_str_xor(case ltrim(rtrim(card_sbalance)) when '' then 'CJ;=D538CL;=' else card_sbalance end))
	from pos_t_vip_info where card_id = @vip_no
	update pos_t_vip_info 
	SET card_amount =card_amount + @fillmoney + @presentmoney,   --修改累计金额
	    card_balance = @card_balance,  --修改明文余额
	    card_sbalance = dbo.fn_str_xor(@card_balance)  --修改加密后的余额
	WHERE card_id = @vip_no
	If @@error <> 0
	Begin
		set @ls_err = '线下登记会员卡号(' + @vip_no + ')金额修改失败(代码' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    	goto rtn 
	End

	if @presentmoney > 0
		set @desc = '微信充值:' + convert(varchar, @fillmoney) + '赠送:' + convert(varchar, @presentmoney)
	else
		set @desc = '微信充值:' + convert(varchar, @fillmoney)
	
	INSERT INTO pos_t_vip_cost ( oper_id , oper_date , card_id , card_cost , card_way , reverse_desc ,actual_payamt ,branch_no ,  other1 ) 
    VALUES ('0000', Getdate(), @vip_no, @fillmoney + @presentmoney, '充值' , @desc, @fillmoney , @branch_no ,  '微信充值')
	If @@error <> 0
	Begin
		set @ls_err = '线下登记会员卡号(' + @vip_no + ')业务操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    	goto rtn 
	End
		insert into kmmicro_t_vip_cost_order (order_no, card_id, oper_type, amount, oper_date)
		values (@order_no, @vip_no, '充值', @fillmoney + @presentmoney, getdate())
		
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
		@flag = pos_t_vip_type.jftype From pos_t_vip_info 
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
	if @flag = '2'
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
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_viptypes'))
begin
	drop procedure kmmicro_Pr_get_viptypes
end 
go
create Procedure [dbo].[kmmicro_Pr_get_viptypes] 
As 
Begin
	Select type_id As 'Key', type_name As 'Value' From pos_t_vip_type
End
go
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_viptype'))
begin
	drop procedure kmmicro_Pr_get_viptype
end 
go
create Procedure [dbo].[kmmicro_Pr_get_viptype] ( 
	@card_id	Varchar(20) 
) 
As 
Begin
	Declare	@err_msg		Varchar(255),
				@card_type	Varchar(2)
	
	If Isnull( @card_id, '' ) = ''
	Begin
		Select @err_msg = '数据参数(card_id)空值异常'
		Goto L_ERR
	End
	
	Select @card_type = Isnull( card_type, '' ) From pos_t_vip_info Where card_id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '检索线下会员信息失败:会员卡号(' + @card_id + ')不存在'
		Goto L_ERR
	End
	
	Select @card_type
	Return 0
	
L_ERR:
	Raiserror(@err_msg, 16, 1)
	Select ''
	Return -1
End
go

/*
获取线下实时库存
kmmicro_Pr_get_inventory
参数 VARCHAR(50)  timeStamp    //时间戳  可为空

timeStamp    为空的时候， 获取全部商品的库存

kmmicro_Pr_get_inventory '2015-08-11 11:00:00', ''

说明：
存储过程名称：kmmicro_Pr_get_inventory
参数：@FROM_date   查询开始时间，如果为空就从使用软件日期开始算   传入的参数日期格式：2015-08-01 10:12:00
      @to_date     查询结束时间，返回（output）为当前时间
返回结果：商品编码item_no，商品名称item_name，库存数量real_qty

*/
IF EXISTS(SELECT 1 FROM sysobjects WHERE xtype = 'P' AND id = object_id('kmmicro_Pr_get_inventory'))
BEGIN
	drop procedure kmmicro_Pr_get_inventory
END
go
CREATE PROCEDURE kmmicro_Pr_get_inventory
	@FROM_date VARCHAR(50),     --//时间戳  可为空
	@to_date VARCHAR(50) output
AS
BEGIN
	SET @to_date = CONVERT(varchar(19), getdate(), 121)
	IF @FROM_date = ''
	BEGIN
		SET @FROM_date = '1900-01-01 00:00:00'
	END
	
	SELECT item.item_no,   --商品编码
	item.item_name,      --商品名称
	sum(isnull(t.real_qty, 0)) real_qty  --变化库存数量
	FROM 
	(SELECT item_no, real_qty FROM ic_t_flow WHERE oper_date BETWEEN @FROM_date AND @to_date
	UNION
	SELECT item_no, (CASE sell_way WHEN 'B' THEN -sale_qnty ELSE sale_qnty END) sale_qnty FROM pos_t_saleflow WHERE oper_date BETWEEN @FROM_date AND @to_date) t
	LEFT JOIN bi_t_item_info item ON (item.item_no = t.item_no)
	GROUP BY item.item_no, item.item_name
	ORDER BY item.item_no

END
go
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_insert_integrate'))
begin
	drop procedure kmmicro_Pr_insert_integrate
end 
go

create Procedure kmmicro_Pr_insert_integrate ( 
	@card_id		Varchar(20),    --会员卡号
	@add_integral	Numeric(14,4)   --增加或减少的积分（正数为增加积分，负数为扣减积分）
) 
As 
Begin
	Declare	@err_msg		Varchar(255),
			@card_status	Varchar(1),
			@sum_saleamt	Numeric(14,4),
			@sum_integral	Numeric(14,4),
			@branch_no		Varchar(6),
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
		select @add_integral = -1 * @add_integral 
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
	If @sum_integral < @add_integral and @mode = '-'
	begin
		Select @err_msg = '会员卡号(' + @card_id + ')的积分少于即将被扣减的积分'
		Goto L_ERR
	end
	
	Select @branch_no = Left( sys_var_value, 4 ) From sys_t_system Where sys_var_id = 'g_branch_no'   --取得当前机构
	
	Begin Tran T1

	update pos_t_vip_info 
	SET vip_integral = vip_integral + (case @mode when '-' then -1 * @add_integral else @add_integral end),
	    total_integral = total_integral + (case @mode when '-' then -1 * @add_integral else @add_integral end)
	WHERE card_id = @card_id
	If @@error <> 0
	Begin
		set @err_msg = '线下登记会员卡号(' + @card_id + ')积分修改失败(代码' + Convert( Varchar, @@error ) + ')'
		goto L_ROLLBACK 
	End
	
	Insert Into pos_t_integral_operating (card_id, oper_type, oper_date, oper_id, oper_descript, 
		sum_saleamt, sum_integral, reduce_amt, reduce_integral, memo, other1, branch_no,com_branch) 
	Values (@card_id, @mode, Getdate(), '0000', @type+'[' + Convert( Varchar, Convert( Int, @add_integral ) ) + ']--会员[' + @card_id + ']', 
		@sum_saleamt, @sum_integral, 0, @add_integral, '线上平台加减积分', '', @branch_no,@branch_no)
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
create Procedure kmmicro_Pr_check_integrate ( 
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
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_onliePaymentFlow_Pay'))
begin
	drop procedure kmmicro_Pr_set_onliePaymentFlow_Pay
end 
go
CREATE procedure [dbo].[kmmicro_Pr_set_onliePaymentFlow_Pay](@SheetNo varchar(32),
			@BranchNo varchar(20),
			@Amount numeric(9,2),
			@CreateDate datetime,
			@WXSheetNo varchar(32),
			@PayType varchar(10),
			@PayResult varchar(5),
			@cVIP_C varchar(50))
as
begin
	insert into kmmicro_t_paymentFlow(SheetNo,BranchNo,Amount,Status,PayStatus,CreateDate,WXSheetNo,PayWay,CardNo)
	values(@SheetNo,@BranchNo,@Amount,'2',@PayResult,@CreateDate,@WXSheetNo,@PayType,@cVIP_C)
end
go

--微信解除会员卡绑定
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_unbindCard'))
begin
	drop procedure kmmicro_Pr_set_unbindCard
end 
go
create procedure kmmicro_Pr_set_unbindCard(@cardno varchar(30))
with encryption 
AS 
Begin 
update pos_t_vip_info set wei_cardid='' where card_id = @cardno
End 
go

--获取商品信息 LZR 2015-12-25
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_iteminfo'))
begin
	drop procedure kmmicro_pr_get_iteminfo
end 
go

CREATE procedure [dbo].[kmmicro_pr_get_iteminfo](@itemno varchar(50))
as
begin
    select item_no ItemNo,item_name ItemName,isnull(unit_no,'') ItemUnit,sale_price Price ,isnull(bi.item_size,'') ItemSize,
        brand.item_clsname Brand,isnull(bi.product_area,'') Origin ,' ' ProductionDate ,bi.valid_days ShelfLife  ,bi.unit_no Packaging ,isnull(bi.item_size,'') Size
     from bi_t_item_info as bi
        left join bi_t_item_cls as brand on(brand.item_clsno = bi.item_brand)
     where bi.item_no=@itemno
end
go