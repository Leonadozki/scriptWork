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
		[PayAmount][numeric](14, 2) NULL,
		DeliveryFee numeric(16,2) null,
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
			@DeliveryFee numeric(16,2),
			@PayAmount numeric(16,2))
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
						DeliveryFee = @DeliveryFee,
						PayAmount =@PayAmount
		where sheet_no=@SheetNo
	else
		insert into kmmicro_t_order_master(Sheet_No,BranchNo,Amount,OpenId,PayFlag,PayWay,DeliveryMode,Linkman,ContactTel,Address,CreateDate,Status,Memo,DeliveryDate,CardId,Payment,DeliveryFee,PayAmount)
		values(@SheetNo,@BranchNo,@Amount,@OpenId,@PayFlag,@PayWay,@DeliveryMode,@Linkman,@ContactTel,@Address,@CreateDate,@Status,@Memo,@DeliveryDate,@CardId,@PayMent,@DeliveryFee,@PayAmount)
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


----10存储过程名：kmmicro_pr_get_clslist，参数：无----用途：用于获取先下类别的级数

if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_clslist'))
begin
	drop procedure kmmicro_pr_get_clslist
end 
go
create procedure kmmicro_pr_get_clslist(@parent_clsno varchar(50))
as
Begin
	select Id  clsno,Name  clsname,ParentId  parentno  from Itemcls where  ParentId=@parent_clsno	
End
go


--6存储过程名：[kmmicro_pr_get_itemslist]，参数：@clsno类别，@keyword模糊查询的参数--用途：用于获取线下商品列表
if exists (select 1 from sysobjects where id = object_id ('kmmicro_pr_get_itemslist'))
begin
	drop procedure kmmicro_pr_get_itemslist
end 
go
create procedure kmmicro_pr_get_itemslist(
	@clsno varchar(50),
	@keyword varchar(200),
	@PageSize		int,				--分页大小
	@CurrentPage	int,				--第N页
	@TotalSize		int		output)		--返回总行数
	as
begin
	select  a.Id ItemNo,a.Name ItemName,isnull(c.Name,'') ItemUnit,RetailPrice Price ,isnull(a.size,'') ItemSize,
       b.name Brand,isnull(a.ProductPlace,'') Origin ,'' ProductionDate ,a.ShelfLife ShelfLife  ,isnull(c.Name,'') Packaging ,isnull(a.size,'') Size ,ROW_NUMBER() over(order by a.Id asc) as RowNo	
      into #temp
     from Item as a
		left JOIN dbo.ItemBrand b ON a.ItemBrandId = b.Id
		left JOIN dbo.Unit c ON a.UnitId = c.Id
      where CHARINDEX(@clsno,ltrim(a.ItemClsId))=1 and  ( a.Id like '%'+@keyword+'%' or a.Name like '%'+@keyword+'%') 
	select @TotalSize=count(1) from #temp 	
	--分页查询.
    select ItemNo,ItemName,ItemUnit,Price,ItemSize,Brand,Origin,ProductionDate,ShelfLife,Packaging,Size from #temp where RowNo between case when  @CurrentPage = 1 then 1 else (@CurrentPage-1) * @PageSize + 1 end and @PageSize*@CurrentPage 
	--释放临时表.
    drop table #temp
end
go


----10存储过程名：kmmicro_Pr_get_OfflineBranchInfo，参数：无----用途：用于获取所有门店

if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_OfflineBranchInfo'))
begin
	drop procedure kmmicro_Pr_get_OfflineBranchInfo
end 
go
create procedure kmmicro_Pr_get_OfflineBranchInfo
as
Begin
	select Id as BranchNo,  Name as BranchName,Linkman as ContractName,Addr as BranchAddres,Tel as BranchTel  from Branch where Property not in ('9','0')
End
go



if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_insertvip')
	DROP PROCEDURE wx_pr_insertvip
go

-- execute wx_pr_insertvip '测试会员', '女', '13011011211', '1995-01-01', '', 'weixinhao'
 create procedure wx_pr_insertvip(@vipname varchar(30),@sex char(5),@viptel char(16),@vipbirth datetime, @pwd char(255),@openid varchar(30) ) 
 as 
 begin 
 	declare @vipno varchar(20) 
 	declare @vipnotmp varchar(20),@maxflow int 
 	declare @ls_err varchar(500) 
 	declare @ll_cardlen int 
 	declare @ls_wxviptype char(50) 
 	declare @ls_viptype char(50),@ls_viptypename char(30) 
 	declare @ll_count int 
 	 
 	select @ll_count = count(Id) from Vip where isnull(other3,'') = @openid and isnull(@openid,'') <> '' 
 	if @ll_count > 0  
 	BEGIN 
 		 /*Modify by Limf 20160202 修改逻辑，有数据，直接更新，不提示已经存在*/
 	    select top 1 @vipno= Id 
 	      from Vip 
 	     where isnull(other3,'') = @openid and isnull(@openid,'') <> ''  
 	    
 	    Update dbo.Vip
 	       Set Name=@vipname,
 	           Sex=(case when @sex = '男' then '0' else '1' end),
 	           Tel=@viptel,
 	           Birthday=@vipbirth
 	     Where Id=@vipno
 	           
 		set @ls_err = '' 
 		goto rtn  
 	END  
	--检查微信会员类别是否存在 
 	select  @ls_wxviptype = Id from VipCls where Id = 'WX' --微会员归属类
 	If @@error <> 0  
 	BEGIN 
 		set @ls_err = '检索会员类别记录失败!' 
 		set @vipno = '' 
 		goto rtn 
 	END 
 	If @ls_wxviptype = '' or @ls_wxviptype is null  
 	BEGIN 
 		set @ls_err =  '系统不存在会员类别'+@ls_wxviptype+'!' 
 		set @vipno = '' 
 		goto rtn  
 	END 
 	--截取会员类别 
 	set @ls_viptype ='WX'
 	select @ls_viptypename  = Name  from VipCls where Id = 'WX'
 	select @vipnotmp = id from Vip where id like 'WXSC%'
 	If @@error <> 0  
 	BEGIN 
 		set @ls_err = '检索会员记录失败!' 
 		set @vipno = '' 
 		goto rtn 
 	END 
 	IF @vipnotmp is null or @vipnotmp=''
 	BEGIN
 		set @vipnotmp='WXSC0000000'
 	END 
 	set @maxflow = convert(int,right(rtrim(@vipnotmp),7 )) 
 	If @maxflow <= 0 or @maxflow is null   set @maxflow = 0 
 	set  @maxflow = @maxflow + 1 
 	set @vipno = 'WXSC'+right(rtrim('0000000' + convert(char,@maxflow)),7) 
 	--插入会员  
	IF NOT EXISTS(SELECT * FROM dbo.Vip WHERE Id =@vipno)
		BEGIN
			INSERT INTO dbo.Vip
			        ( Id ,Sn ,VipClsId ,CardFlag ,OriginalId ,FlowId ,
			          Status ,BeginDate ,EndDate ,MakeDate ,RegistDate ,SendDate ,
			          BranchId ,Name ,Sex ,Height ,Grade ,IdentityCardId ,Weight ,Tel ,
			          Mobile ,Zip ,Email ,QQ ,Birthday ,Addr ,WorkUnit ,VipRegionId ,
			          TradeId ,Dues ,TotalConsTimes ,TotalConsAmt ,TotalIntegral ,Integral ,
			          RechargingAmt ,Balance ,EncryptBalance ,Deposit ,AncillaryId1 ,AncillaryId2 ,
			          Password ,Other1 ,Other2 ,Other3 ,Num1 ,Num2 ,Num3 ,LastConsumeDate ,
			          OperId ,OperDate ,AcceptMessageFlag ,LoginAccount ,LoginPassword ,
			          VipOnlinePayFlag ,IntroduceCard ,SmallChange
			        )
			SELECT @vipno,NULL,@ls_viptype,'1',NULL,NULL,
			'2',GETDATE(),DATEADD(YEAR,3,GETDATE()),GETDATE(),NULL,NULL,
			'00',@vipname,case when @sex = '男' then '0' else '1' end,'','','','','',
			@viptel,'','','',@vipbirth,'','','',
			'',0,0,0,0,0,
			0,0,NULL,0,NULL,NULL,@pwd,NULL,NULL,@openid,0,0,0,NULL,
			NULL,NULL,1,@vipno,@pwd,'0','',NULL
			
		END
 	If @@error <> 0  
 	BEGIN 
 		set @ls_err = '注册会员失败!' 
 		set @vipno = '' 
 		goto rtn 
 	END 
 	select @vipno 
 	return 
 	rtn: 
 	If len(@ls_err) > 0 or @ls_err is null 
 		raiserror(@ls_err,16,1)  
 	select @vipno 
 end 
go


--绑定会员卡
--绑定会员卡
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_checkVIP')
	DROP PROCEDURE wx_pr_checkVIP
go
 create procedure wx_pr_checkVIP (@as_vipno char(20),@as_pwd char(255),@openid varchar(30)) --密码是加密后的密码 @openid:微信号
 as 
 Begin 
 	declare @ll_count int 
 	declare @ls_cardid varchar(30)
 	declare @ls_pwd varchar(255)
 	declare @ls_operid varchar(30)
	declare @ic_flag varchar(1)
 	select @ll_count = Count(*) from Vip where id = @as_vipno 
	If @@error <> 0   
	 	BEGIN 
	 		raiserror('检索会员失败!',16,1) 
	 		set @ll_count = 0 
	      set @ls_cardid = ''
	 		goto rtn 
	 	END 
	If @ll_count = 0 --未检索到卡号，这检索有没有对应的手机号
		BEGIN
	      select @ll_count = count(*) from vip where isnull(Tel, '') = @as_vipno
	      if @@error <> 0
				BEGIN 
			 		raiserror('检索会员失败!',16,1) 
			 		set @ll_count = 0 
			      set @ls_cardid = ''
			 		goto rtn 
			 	END 
			IF @ll_count = 1 --有手机号对应，并且唯一
				BEGIN
					select @ls_cardid = id, @ls_pwd = isnull(Password, ''), @ls_operid = isnull(other3, '') from vip where isnull(Tel, '') = @as_vipno
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
	 		select @ls_cardid = id ,@ls_pwd = isnull(Password,'')  ,@ls_operid = isnull(other3,'') from vip where id = @as_vipno   
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
 	--检查是否已被别的微信绑定 
 	If @ls_operid <> @openid  and rtrim(ltrim(@ls_operid)) <> '' 
 	BEGIN 
 		raiserror('该会员已被另一个微信账号绑定，不允许再绑定!',16,1)   
 		set @ll_count = 0   
 		set @ls_cardid = '' 
   	goto rtn   
 	END 

	SELECT @ic_flag = cardflag FROM VIP WHERE id = @ls_cardid
	IF UPPER(@ic_flag) = '2' 
	BEGIN
		raiserror('该会员为IC卡，不允许再绑定!',16,1)   
 		set @ll_count = 0   
 		set @ls_cardid = ''
		goto rtn  
	END
	
	--检查密码是否正确 
 	If @ls_pwd = isnull(@as_pwd,'')
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
  	update vip set other3 = @openid where  id = @ls_cardid and isnull(Password,'') = @ls_pwd   
  	rtn:  
   	select  convert(char(1),@ll_count)+ @ls_cardid    
   End   
go

--获取会员卡基本信息
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_getvipinfo')
begin
	DROP PROCEDURE wx_pr_getvipinfo
end
go
create procedure wx_pr_getvipinfo (@as_vipno varchar(20))  
as
Begin
	SELECT  id as card_id,   --卡号
 			Name as vip_name,   --会员名称
			VipClsId as card_type, --会员卡类别 
 	        case when Sex='0' then '男' else '女' end  as  vip_sex,   --性别
 	        IdentityCardId as vip_idno, --身份证号码 	        Addr as vip_add,    --会员地址
 	        WorkUnit as job_add,   --工作单位
 	        Zip as vip_zip,  --会员邮编
 	        Mobile as vip_tel,   --会员手机
 	        Mobile as vip_mobile,   --会员电话        chenhd
 	        Email as vip_email,   --会员邮箱
 	        VipRegionId as vip_area,   --会员所属区域 	        TradeId as vip_vocation,   --会员所在行业 	        '' as validate_flag,   --是否起用有效期控制 	        BeginDate as vip_start_date,   --开始有效期
 	        EndDate as vip_end_date,   --结束有效期			Balance as card_balance,
 	        '' as vip_avocation,   --业余爱好
 	        convert(char(10),Birthday,120) as vip_birth_date,  --阳历生日 （微信只显示阳历生日） 	        '' as vip_birth2_date, --阴历生日   
 	        '' as vip_earning,   --会员收入
 	        '' as vip_favorbrand,   --喜欢的品牌        
 	        '' as remark,   --备注                chenhd
 	        '' as cEmp_c, --业务员               chenhd
 	        CONVERT(numeric(14,2),TotalConsAmt) as vip_cons_amount,   --累计消费金额
 	        TotalConsTimes as cons_count,   --累计消费次数     
 	        CONVERT(numeric(14,2),Integral ) as vip_integral,  --当前积分 
 	        CONVERT(numeric(14,2),TotalIntegral ) as total_integral,  --累计积分  
 	        CONVERT(numeric(14,2),RechargingAmt ) as card_amount,  --累计充值总额 
 	        (case status when '5' then '未生效' when '2' then '正常' when '3' then '无效' when '4' then '挂失' when '3' then '回收' else '未知' end ) card_status ,   --卡状态
 	        (select name from vipcls where id = VipClsId) as type_name   --卡类别 	
 	        FROM vip 
 	WHERE id = @as_vipno 
End 
go


--会员消费记录查询  
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_getvipcost')
	DROP PROCEDURE wx_pr_getvipcost
go
 create procedure wx_pr_getvipcost (@as_vipno varchar(12),@as_from varchar(20),@as_to varchar(20)) --时间参数yyyy-mm-dd
 as 
 Begin 
 	select 
		Retail.Id as cbill_c, Retail.BranchId as branch_no,
		 Branch.Name as branch_name,
		 Retail.OperDate as oper_date, 
		SUM( RetailEntry.SubAmt) as card_cost 
		from Retail, RetailEntry, Branch, Vip
		where Retail.Id = RetailEntry.SheetId 
		and Retail.SellWay='A'
		and Retail.BranchId = Branch.Id 
		and Retail.VipId = Vip.Id 
		and Retail.VipId=@as_vipno
		and convert(char(10),Retail.OperDate,120) between @as_from  and @as_to
		group by Retail.Id ,Retail.BranchId ,Branch.Name, Retail.OperDate 
		order by oper_date desc
 End  
go


--积分流水查询
if exists( select * from sysobjects where xtype = 'P' and name = 'wx_pr_getvipintegral')
	DROP PROCEDURE wx_pr_getvipintegral
go
 create procedure wx_pr_getvipintegral (@as_vipno varchar(12),@as_from varchar(20),@as_to varchar(20)) 
 as  
 begin 
 		select   IntegralFlow.BranchId as branch_no, Branch.Name as branch_name, 
		 IntegralFlow.OperDate as oper_date,
		 DictTable.OptionName as oper_descript, 
		 IntegralFlow.Integral as reduce_integral
		 from IntegralFlow, Branch,  BranchCls, Vip,  DictTable
	  where IntegralFlow.BranchId = Branch.Id 
	   and Branch.BranchClsId = BranchCls.Id 
	   and IntegralFlow.VipId = @as_vipno
	   and IntegralFlow.VipId = Vip.Id 	   
	   and IntegralFlow.OperType = DictTable.OptionId 
	   and DictTable.DictType = 'OperType' 
	   and convert(char(10),IntegralFlow.OperDate,120) between @as_from and @as_to 
 	order by oper_date desc
 end 
go


--查询余额
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_get_cardbalanch'))
begin
	drop procedure kmmicro_Pr_get_cardbalanch
end 
go
create  procedure kmmicro_Pr_get_cardbalanch(@vip_no varchar(20))
as
begin   
	select ID as cardno, Balance  as card_balance  from Vip where ID = @vip_no
end
go


--充值前检查会员卡信息
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

	Select  @card_status = Isnull( status, '' ),
		@flag = CardFlag From Vip 
	where  id = @vip_no
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		set @ls_err = '检索线下会员信息失败:会员卡号(' + @vip_no + ')不存在'
		set @ll_rtn = -1 
    		goto rtn 
	End
	If @card_status <> '2'
	Begin
		set @ls_err = '会员卡号(' + @vip_no + ')线下处于非正常状态'
		set @ll_rtn = -1 
    		goto rtn 
	End	
	if @flag = '2'
	begin
		set @ls_err = 'IC卡不允许网上充值'
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

--增加减少积分
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
			@sum_integral	Numeric(14,4)
	
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
	Select @card_status = Isnull( status, '' ), @sum_saleamt = Isnull( TotalConsAmt, 0 ), @sum_integral = Isnull( TotalIntegral, 0 ) 
	From Vip Where id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '检索线下会员信息失败:会员卡号(' + @card_id + ')不存在'
		Goto L_ERR
	End
	If @card_status <> '2'
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')线下处于非正常状态'
		Goto L_ERR
	End
		
	Begin Tran T1					
	UPDATE dbo.Vip SET Integral = Integral+@add_integral,
						TotalIntegral = TotalIntegral+@add_integral WHERE Id = @card_id	
	If @@error <> 0
	Begin
		set @err_msg = '线下登记会员卡号(' + @card_id + ')积分修改失败(代码' + Convert( Varchar, @@error ) + ')'
		goto L_ROLLBACK 
	End
	
	insert into dbo.IntegralFlow
	( VipId ,BranchId ,OperType ,OperId ,OperDate ,OperDescription ,Amt ,Integral ,TotalConsAmt ,SettleIntegral ,Memo ,Num1,Num2)     
	SELECT @card_id,'00','2','9001',GETDATE(),'网上商城积分变更',0,@add_integral,@sum_saleamt,@sum_integral+@add_integral,'', 0,0
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


--积分兑换检查积分
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
		
	Select @card_status = Isnull( status, '' ), @sum_integral = Isnull( totalintegral, 0 ) 
	From Vip Where Id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '检索线下会员信息失败:会员卡号(' + @card_id + ')不存在'
		set @ll_rtn = -1 
		Goto L_ERR
	End
	If @card_status <> '2'
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


--会员卡解绑
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_unbindCard'))
begin
	drop procedure kmmicro_Pr_set_unbindCard
end 
go
create procedure kmmicro_Pr_set_unbindCard(@cardno varchar(30))
with encryption 
AS 
Begin 
update Vip set other3='' where id = @cardno
End 
go


--会员卡修改密码
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
	
	select @ll_count = count(1) from Vip where id = @cardid;
	
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
	
	select @card_pw = Password from Vip where id = @cardid
	
	if @card_pw is not null or @oldpw <> ''
	begin
		if @card_pw <> @oldpw
		begin
			set @ls_err = '原密码错误'
			set @ll_rtn = -1 
    		goto rtn 
		end
	end
	
	update vip set Password = @newpw where id = @cardid
	
	--写修改会员密码日志

	
	rtn:
   	If len(@ls_err) > 0 or @ls_err  is not null   
    	raiserror(@ls_err,16,1)  
    	select @ll_rtn   
end
go

--会员卡线上支付
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
	@encryptBalance  Varchar(100),		--加密后的余额
	@err_msg		Varchar(255) Output	--返回错误信息
) 
As 
Begin
	Declare	@vip_name		Varchar(30),
				@card_status	Varchar(1),
				@card_balance	Numeric(12,2)
	
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

	
	Select @vip_name = Isnull( Name, '' ), @card_status = Isnull( status, '' ), @card_balance = Isnull(Balance, 0 ) 
	From Vip Where id = @card_id
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		Select @err_msg = '检索线下会员信息失败:会员卡号(' + @card_id + ')不存在'
		Return -1
	End
	If @card_status <> '2'
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')线下处于非正常状态'
		Return -1
	End
	If @trans_amt > 0 And @card_balance < @trans_amt
	Begin
		Select @err_msg = '会员卡号(' + @card_id + ')线下的储值余额不足(差额 ' + Convert( Varchar, @trans_amt - @card_balance ) + ' 元)'
		Return -1
	End
	
	DECLARE @MaxFlowId NUMERIC(16,0)
	SELECT @MaxFlowId =  MAX(FlowId) FROM VipCashFlow WHERE VipId = @card_id
	
	Begin Tran T1 
	UPDATE Vip SET Balance = Balance - @trans_amt,EncryptBalance = @encryptBalance WHERE Id = @card_id	
	If @@error <> 0
	Begin
		Select @err_msg = '线下登记会员卡号(' + @card_id + ')更新余额失败(代码' + Convert( Varchar, @@error ) + ')'
		Goto L_ERR
	End
	
	insert into dbo.VipCashFlow
	( VipId ,AcqtualAmt ,PayAmt ,BalanceAmt ,Type ,OperId ,OperDate ,BranchId ,Memo ,SheetId ,ItemId ,UseCounter)     
	SELECT @card_id,@trans_amt,@trans_amt,BalanceAmt-@trans_amt,'1','9001',GETDATE(),'00','网上商城消费','','',0
	FROM dbo.VipCashFlow WHERE VipId = @card_id AND FlowId = @MaxFlowId	
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

--会员卡充值
if exists (select 1 from sysobjects where id = object_id ('kmmicro_Pr_set_fillmoney'))
begin
	drop procedure kmmicro_Pr_set_fillmoney
end 
go
create procedure kmmicro_Pr_set_fillmoney(
	@vip_no varchar(20),          --会员卡号
	@encryptBalance VARCHAR(100), --充值后的余额			
	@fillmoney Numeric(12,2),     --充值金额
	@presentmoney Numeric(12,2)  --赠送金额		
)
as
begin  
	declare @ls_err         varchar(500),     --错误信息
			@ll_rtn         int,              --返回值：1成功，0失败  
			@card_status	Varchar(1),	      --会员状态
			@card_balance	Numeric(14,4),	  --充值后余额
			@flag			varchar(1)       --标志	  
	
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
	
	Select  @card_status = Isnull( status, '' ),
			@flag = b.SavingFlag			
	From Vip 
	inner join vipcls b on Vip.vipclsId=b.Id
	and Vip.id = @vip_no
	If @@error <> 0 Or @@rowcount <> 1
	Begin
		set @ls_err = '检索线下会员信息失败:会员卡号(' + @vip_no + ')不存在'
		set @ll_rtn = -1 
    	goto rtn 
	End
	If @card_status <> '2'
	Begin
		set @ls_err = '会员卡号(' + @vip_no + ')线下处于非正常状态'
		set @ll_rtn = -1 
    	goto rtn 
	End	
	if @flag = '0'
	begin
		set @ls_err = '会员卡号(' + @vip_no + ')线下为不允许储值状态'
		set @ll_rtn = -1 
    	goto rtn 
	end
	
	BEGIN TRANSACTION
	DECLARE @MaxFlowId BIGINT
	SELECT @MaxFlowId =  MAX(FlowId) FROM VipCashFlow WHERE VipId = @vip_no
	insert into dbo.VipCashFlow
	( VipId ,AcqtualAmt ,PayAmt ,BalanceAmt ,Type ,OperId ,OperDate ,BranchId ,Memo ,SheetId ,ItemId ,UseCounter)     
	SELECT @vip_no,@fillmoney,@fillmoney+@presentmoney,BalanceAmt+@fillmoney+@presentmoney,'0','9001',GETDATE(),'00','网上商城充值','','',0
	FROM dbo.VipCashFlow WHERE VipId = @vip_no AND FlowId = @MaxFlowId	
	if @@error <> 0 
	Begin
		set @ls_err = '线下登记会员卡号(' + @vip_no + ')业务操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    	goto rtn 
	End
	DECLARE @SheetNo VARCHAR(16)
	EXEC sys_pr_get_sheetno 'VR','00',@SheetNo output
	
	INSERT INTO dbo.VipRecharge
	(Id ,Type ,BranchId ,VipId ,Amount ,BusinessDate ,OperId ,OperDate ,OperBranchId ,Memo ,PayAmt ,RechargeSchemeId)
	SELECT @SheetNo,'VR','',@vip_no,@fillmoney,GETDATE(),'9001',GETDATE(),'00','网上商城充值',@fillmoney+@presentmoney,''
	
	if @@error <> 0 	
	Begin
		set @ls_err = '线下登记会员卡号(' + @vip_no + ')业务操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    	goto rtn 
	End
	DECLARE @Sequence INT
	SELECT @Sequence = ISNULL(MAX(Sequence),0)+1 FROM dbo.VipRechargeEntry WHERE SheetId = @SheetNo
	
	INSERT INTO dbo.VipRechargeEntry
	(SheetId , Sequence ,PayWay ,CardId ,CoinId ,ExchangeRate ,PayAmt ,Memo ,SellWay)
	SELECT @SheetNo,@Sequence,'A',@vip_no,'',1,@fillmoney+@presentmoney,'网上商城充值','A'
	 
	if @@error <> 0 
	
	Begin
		set @ls_err = '线下登记会员卡号(' + @vip_no + ')业务操作流水失败(代码' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    	goto rtn 
	End	
	UPDATE dbo.Vip SET Balance = Balance + @fillmoney+@presentmoney,EncryptBalance = @encryptBalance,RechargingAmt=RechargingAmt+@fillmoney+@presentmoney WHERE Id = @vip_no	
	if @@error <> 0 
	
	Begin
		set @ls_err = '线下登记会员卡号(' + @vip_no + ')金额修改失败(代码' + Convert( Varchar, @@error ) + ')'
		set @ll_rtn = -1 
    	goto rtn 
	End
	COMMIT
	
    	set @ll_rtn = 1 
	
	rtn:
   	If len(@ls_err) > 0 or @ls_err  is not null   
    	raiserror(@ls_err,16,1)  
    	select @ll_rtn   
end
go

/*
 触发器名称: Bi_Tr_Trace_kmmicro_t_order_master
*/

---如果触发器已经存在则删除
if exists (select 1 from sysobjects where id = object_id('Bi_Tr_Trace_kmmicro_t_order_master'))
	drop trigger Bi_Tr_Trace_kmmicro_t_order_master
go
create trigger Bi_Tr_Trace_kmmicro_t_order_master on kmmicro_t_order_master
with encryption 
for insert
--for insert, delete, update
as  
begin
	set NOCOUNT ON
    if exists(select top 1 1 from inserted)
    BEGIN
		DECLARE @Id VARCHAR(30)
		SELECT @Id = Sheet_No FROM inserted
		IF NOT EXISTS(SELECT * FROM dbo.Retail_O2O WHERE Id =@Id)
		BEGIN
			INSERT INTO dbo.Retail_O2O
			        ( Id ,BranchId ,Sellway ,Amount ,OperDate ,
			          BusinessDate ,VoucherId ,VipId ,O2oOrderno ,PayFlag ,ConAddr ,
			          ConMobile ,Consignee ,EarnedReward ,DownFlag,PickUpType,SendDate,DeliveryFee,PayAmount,Memo
			        )
			SELECT @Id,BranchNo,'A',Amount+DeliveryFee,CreateDate,CONVERT(varchar(100),GETDATE(),23),'',CardId,@Id,PayFlag,Address,ContactTel,Linkman,CONVERT(int,Amount),1,DeliveryMode,CONVERT(varchar(12),year(DeliveryDate))+'年'+CONVERT(varchar(12),month(DeliveryDate))+'月'+CONVERT(varchar(12),day(DeliveryDate))+'日'			,DeliveryFee,PayAmount,Memo
			FROM inserted
		END
		return 
    end
end

go


/*
 触发器名称: Bi_Tr_Trace_kmmicro_t_order_detail
*/
---如果触发器已经存在则删除
if exists (select 1 from sysobjects where id = object_id('Bi_Tr_Trace_kmmicro_t_order_detail'))
	drop trigger Bi_Tr_Trace_kmmicro_t_order_detail
go
-----OriginalPrice暂时当原价，等O2O组修改
-----定义触发器(插入/修改--insert )
create trigger Bi_Tr_Trace_kmmicro_t_order_detail on kmmicro_t_order_detail
with encryption 
for insert
--for insert, delete, update
as  
begin
	set NOCOUNT ON
    if exists(select top 1 1 from inserted)
    BEGIN
			INSERT INTO dbo.RetailEntry_O2O
			        ( SheetId ,Sequence ,ItemId ,OriginalPrice,ActualPrice ,ActualQty,SubAmt)
			SELECT sheet_no,Sequence,ItemNo,SalePrice,SalePrice,SaleQty,SaleAmt
			FROM inserted
		return 
    end
end

go

---如果触发器已经存在则删除
if exists (select 1 from sysobjects where id = object_id('Bi_Tr_Trace_kmmicro_pos_t_payflow_pre'))
	drop trigger Bi_Tr_Trace_kmmicro_pos_t_payflow_pre
go
-----OriginalPrice暂时当原价，等O2O组修改
-----定义触发器(插入/修改--insert )
create trigger Bi_Tr_Trace_kmmicro_pos_t_payflow_pre on kmmicro_pos_t_payflow_pre
with encryption 
for insert
--for insert
as  
begin
	set NOCOUNT ON
    if exists(select top 1 1 from inserted)
    BEGIN
			INSERT INTO dbo.RetailPay_O2O
			        ( SheetId ,PayWay ,SellWay ,CardId,PayAmt)
			SELECT sheet_no,pay_way,sell_way,card_no,pay_amount
			FROM inserted
		return 
    end
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
	Select Id As 'Key', name As 'Value' From Vipcls
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
	
	Select @card_type = Isnull(VipClsId , '' ) From vip Where id = @card_id
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









