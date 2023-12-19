WITH RECURSIVE numbers AS (
  SELECT 0 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < DATEDIFF(CURDATE(),'2023-01-01') -- Adjust the range here
)

, date_array as (
SELECT DATE_ADD('2023-01-01', INTERVAL n DAY) AS date_array
FROM numbers
)

, raw_student_infor as 
(
SELECT 
	name, # student id  EDU-STU-2023-00001
	creation, # creation date
	modified, # modified date
	modified_by, 
	owner,
	docstatus,
	idx,
	enabled, # 0 & 1 meaning ? 
	# student infor
	first_name,
	middle_name,
	last_name,
	naming_series,
	joining_date,
	user,
	student_applicant,
	image,
	student_email_id,
	date_of_birth,
	age,
	# thong tin dia diem hoc
	branch, # dia diem hoc
	company,
	nick_name,
	student_name,
	status, # status cua hoc vien Frozen/Withdraw/Active
	student_mobile_number,
	gender,
	address_line_1,
	address_line_2,
	state,
	country,
	date_of_leaving,
	blood_group,
	nationality,
	pincode,
	city,
	# 
	first_instructor # 1st giao vien
	leaving_certificate_number,
	reason_for_leaving
FROM `tabStudent`
)
, raw_student_attendance as 
(
SELECT 
	name, # attendance id EDU-ATT-2023-00002
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	naming_series,
	student, # student id EDU-STU-2023-00204
	student_name, # 
	student_mobile_number,
	course_schedule, # thong tin lop hoc EDU-CSH-2023-00014
	student_group, # nhom hoc sinh
	date, # attendance_date
	status, # status tham du lop hoc Present/ Absent
	leave_application, 
	amended_from
FROM `tabStudent Attendance`
)
, raw_course_infor as (
SELECT 
	name, # Course Name BrainFlash
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	course_name,
	department,
	hero_image,
	description, # Rental/Online Class/Physical Class
	default_grading_scale,
	_user_tags,
	_comments,
	_assign,
	_liked_by
FROM `tabCourse`
)
, raw_course_enrollment as (
SELECT 
	name, #program id EDU-CE-2023-00001
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	program_enrollment, #EDU-ENR-2023-00001
	program, # SPC Early Childhood
	enrollment_date, # ngay dang ky 
	course, # SPC_Early Childhood_WE
	student, # student id EDU-STU-2023-00204
	student_name
FROM `tabCourse Enrollment`
)
, raw_course_schedule as #lich hoc cua tung khoa
( 
SELECT 
	name, # EDU-CSH-2023-00009
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	student_group, # SAT - 10:00 - AN PHU - LAN ANH
	instructor,
	instructor_name,
	naming_series,
	program, # Program 2023
	course, # SPC_Early Childhood_WE
	color,
	schedule_date,
	room,
	from_time, # 10:13:05.000000
	to_time, # 19:37:46.000000
	title, # BrainPlay by Le Tran Thi Lan Anh
	_user_tags,
	_comments,
	_assign,
	_liked_by
FROM `tabCourse Schedule`
)
, raw_instructor as
(
SELECT 
	name, # instructor id
	creation, 
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	# detail infor
	instructor,
	instructor_name,
	parent,
	parentfield,
	parenttype
FROM `tabStudent Group Instructor`
)
, raw_student_guardian as # thong tin phu huynh
(
SELECT 
	name, # guardian id 
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	# thong tin phu huynh
	guardian, # guardian id 
	guardian_name,
	relation, # moi quan he
	parent, 
	parentfield,
	parenttype
FROM `tabStudent Guardian` # thong tin phu huynh
)
, raw_lead as ( # moi 1 lead chi show 1 row
SELECT 
	name, # lead id CRM-LEAD-2023-00001
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	naming_series,
	salutation,
	# lead infor 
	first_name, # lead name
	middle_name,
	last_name, 
	lead_name, # lead name
	job_title,
	gender,
	source, # Facebook/Callin/Campaign
	lead_owner, 
	status, # Converted/ Do Not Contact/Interested/Lead/Lost Quotation/Open/Opportunity/Quotation/Replied
	customer,
	type,
	request_type,
	email_id,
	website,
	mobile_no,
	whatsapp_no,
	phone,
	phone_ext,
	company_name,
	no_of_employees,
	annual_revenue,
	industry,
	market_segment,
	territory,
	fax,
	city,
	state,
	country,
	qualification_status,
	qualified_by,
	qualified_on,
	campaign_name,
	company,
	language,
	image,
	title,
	disabled,
	unsubscribed,
	blog_subscriber,
	day_of_birth,	
	nick_name,	
	district,	
	create_date,	
	lost_reason,	
	course_list,	
	payment_status,	
	branch,	
	age,
	lead_type
FROM `tabLead`
)
, raw_payment_schedule as 
(
SELECT
	name, # payment id ? 3c947df291
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	payment_term,
	description,
	due_date, # 2023-05-26
	mode_of_payment,
	invoice_portion, # 100.000000000
	discount_type,
	discount_date,
	discount,
	payment_amount,
	outstanding,
	paid_amount,
	discounted_amount,
	base_payment_amount,
	parent, # Quotation: SAL-QTN-2023-00003/ Sales Invoice: ACC-SINV-2023-00001/ Sales Order: SAL-ORD-2023-00001
	parentfield,# payment_schedule
	parenttype # Quotation/ Sales Invoice/ Sales Order
FROM `tabPayment Schedule`
)

, raw_sales_invoice as (
SELECT
	name, # invoice id ACC-SINV-2023-00001
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	title,
	naming_series,
	customer, # Phạm Nhật Châu Anh
	customer_name, # Phạm Nhật Châu Anh
	tax_id, 
	company, #Shichida
	company_tax_id, # 30
	due_date, # payment due date 6/30/2023
	update_billed_amount_in_sales_order,
	cost_center, # Main - Shichida
	selling_price_list, # Standard Selling
	price_list_currency,
	plc_conversion_rate,
	ignore_pricing_rule,
	scan_barcode,
	update_stock,
	set_warehouse,
	set_target_warehouse,
	########## so luong buoi hoc
	total_qty, # 10 
	total_net_weight,
	base_total, # 6000000
	base_net_total, # 6000000
	total,
	net_total,
	status, ############# Overdue/Paid/Unpaid
	inter_company_invoice_reference,
	represents_company,
	customer_group, ########### Individual/Commercial/Government
	is_internal_customer,
	is_discounted,
	remarks
FROM `tabSales Invoice`
)

, raw_sales_invoice_item as 
(
SELECT 
	name, # 01eab1cfb2
	creation,
	modified,
	modified_by,
	owner,
	docstatus,
	idx,
	barcode,
	has_item_scanned,
	item_code, # BrainFlash/ Deposit_BF/BP/ ePlayLearn_WE_11B_NEW/ ePrenatal_8B
	item_name, # BrainFlash
	customer_item_code,
	description,
	item_group,
	brand,
	image,
	qty, # 10
	stock_uom, #Package_1Month	
	uom, #Package_1Month
	conversion_factor,
	stock_qty, # 10
	price_list_rate, # 600000
	base_price_list_rate, # 600000
	sales_order,# SAL-ORD-2023-00001
	so_detail, # 5639a830e8
	sales_invoice_item,
	delivery_note,
	dn_detail,
	delivered_qty,
	purchase_order,
	purchase_order_item,
	cost_center, # Main - Shichida
	parent, # ACC-SINV-2023-00001
	parentfield, # items
	parenttype # Sales Invoice
FROM `tabSales Invoice Item`
)

, raw_sales_invoice_final as 
(
SELECT 
	a.name,
	a.customer, # Phạm Nhật Châu Anh
	a.customer_name, # Phạm Nhật Châu Anh
	a.due_date,
	a.total_qty,
	###
	b.sales_order, # SAL-ORD-2023-00001
	b.qty,
	b.item_code,
	b.item_name
FROM  raw_sales_invoice a
LEFT JOIN raw_sales_invoice_item b ON b.parent = a.name
)

,raw_final as (
SELECT DISTINCT
	a.name as program_id, #program id EDU-CE-2023-00001
	a.creation,
	a.enrollment_date, # ngay dang ky 
	a.program_enrollment, #EDU-ENR-2023-00001
	a.program, # SPC Early Childhood
	a.course, # SPC_Early Childhood_WE
	# student infor
	a.student, # student id EDU-STU-2023-00204
	a.student_name,
	b.branch,
	b.status as student_status,
#### course schedule
	c.instructor,
	c.instructor_name,
	#c.program as course_schedule_program, # Program 2023
	c.name,
	#c.schedule_date,
	#c.room,
	#c.from_time, # 10:13:05.000000
	#c.to_time, # 19:37:46.000000

#### sales invoice
	d.total_qty,
	d.qty,
	CASE WHEN e.status = 'Present' THEN 1 ELSE 0 END present_qty,
#### student attendace
	e.name as attendence_id, # attendance id EDU-ATT-2023-00002
	e.course_schedule, # thong tin lop hoc EDU-CSH-2023-00014
	e.student_group, # nhom hoc sinh
	e.date, # attendance_date
	e.status, # status tham du lop hoc
	e.leave_application,
#### date
	e1.date_array,
	DATE_ADD(e1.date_array, INTERVAL (- DAYOFWEEK(e1.date_array) + 1) DAY) as begin_of_week
	#DATE_FORMAT(e1.date_array, '%Y-%m-01') AS begin_of_month

FROM raw_course_enrollment a
LEFT JOIN raw_student_infor b ON b.name = a.student
LEFT JOIN raw_course_schedule c ON a.course = c.course### so buoi da diem danh
LEFT JOIN date_array e1 ON e1.date_array >= DATE_ADD(a.enrollment_date, INTERVAL -30 DAY) 
### tong so buoi
LEFT JOIN raw_sales_invoice_final d ON d.customer_name = a.student_name AND d.item_name = a.course
LEFT JOIN raw_student_attendance e ON e.student = b.name AND e.course_schedule = c.name AND e.date = e1.date_array
WHERE 1=1
# AND a.student_name = 'Pham Huy Quang'
# 'Phạm Nhật Châu Anh'
# AND c.name = 'EDU-CSH-2023-00010'

ORDER BY e.date ASC
)

, raw_final_1 as (
SELECT a.*, 
SUM (a.total_present_qty_week) OVER (PARTITION BY a.student, a.course, a.name ORDER BY a.begin_of_week ASC) as total_present_qty_week_accumulate
FROM 
(
SELECT DISTINCT
		a.program_id, #program id EDU-CE-2023-00001
		a.creation,
		a.enrollment_date, # ngay dang ky 
		a.program_enrollment, #EDU-ENR-2023-00001
		a.program, # SPC Early Childhood
		a.course, # SPC_Early Childhood_WE
		# student infor
		a.student, # student id EDU-STU-2023-00204
		a.student_name,
		a.branch,
		a.student_status,
	#### course schedule
		a.instructor,
		a.instructor_name,
		a.name,

	#### sales invoice
		a.total_qty,
		#a.present_qty,
	 ###
	 	a.begin_of_week, 
		SUM (a.present_qty) OVER (PARTITION BY a.student, a.course, a.name, a.begin_of_week) as total_present_qty_week		
FROM
	(
		SELECT DISTINCT
			a.program_id, #program id EDU-CE-2023-00001
			a.creation,
			a.enrollment_date, # ngay dang ky 
			a.program_enrollment, #EDU-ENR-2023-00001
			a.program, # SPC Early Childhood
			a.course, # SPC_Early Childhood_WE
			# student infor
			a.student, # student id EDU-STU-2023-00204
			a.student_name,
			a.branch,
			a.student_status,
		#### course schedule
			a.instructor,
			a.instructor_name,
			a.name,

		#### sales invoice
			a.total_qty,
			a.present_qty,
		 ###
		 	a.begin_of_week
		 # a.date_array
		FROM raw_final a
	) a
) a 
) 

SELECT 
*,
IF(IFNUll(total_qty,0) - IFNULL(total_present_qty_week_accumulate,0) < 0, 0, IFNUll(total_qty,0) - IFNULL(total_present_qty_week_accumulate,0)) as total_qty_left 

FROM raw_final_1 