/*===================================== SV: Nguyen Manh Ha - FX13850 - ASM2 ====================================*/
/*============================================ CREATE AT 03-03-2022 ============================================*/

-- Yêu cầu 1: Tạo cơ sở dữ liệu
CREATE DATABASE CSDL_ASM_2
GO
USE CSDL_ASM_2
GO

--1.1
CREATE TABLE Du_thao(
	Ma_du_thao VARCHAR(10) PRIMARY KEY,
	TG_gui_bai DATE NOT NULL,
	So_lan_sua INT DEFAULT 0,
	Trang_thai NVARCHAR(20) NOT NULL DEFAULT N'Chờ phê duyệt',
	Ma_phong_vien VARCHAR(10) NOT NULL,	
	Ma_BTV VARCHAR(10) NOT NULL);
ALTER TABLE Du_thao ADD CONSTRAINT Check_Trang_thai CHECK( Trang_thai IN 
		(N'Đã đăng tải', N'Được lên lịch đăng', N'Đã phê duyệt đăng', N'Đang sửa', N'Chờ phê duyệt'));
--1.2
CREATE TABLE Bai_viet(
	Ma_bai_viet VARCHAR(10) PRIMARY KEY,
	Ten_bai_viet NVARCHAR(100) NOT NULL,
	Noi_dung NVARCHAR(4000) NOT NULL,
	TG_dang_bai DATETIME NULL, -- Sử dụng TRIGGER để cập nhật TG đăng bài theo giờ hiện tại
	Ma_du_thao VARCHAR(10) NOT NULL,
	Ma_chuyen_muc VARCHAR(10) NULL, -- Có thể sử dụng TRIGGER để cập nhật
	Ma_phong_vien VARCHAR(10) NULL,	-- Có thể sử dụng TRIGGER để cập nhật
	Ma_BTV VARCHAR(10));
ALTER TABLE Bai_viet ADD CONSTRAINT Check_Ngay_bai_viet CHECK( TG_dang_bai <= CURRENT_TIMESTAMP);

--1.3
CREATE TABLE Phong_vien(
	Ma_phong_vien VARCHAR(10) PRIMARY KEY,
	Email_PV VARCHAR(30) NOT NULL UNIQUE,
	Ho_ten NVARCHAR(30) NOT NULL,
	Do_tin_cay INT DEFAULT 50,
	Ma_chuyen_muc VARCHAR(10) NOT NULL);
--1.4
CREATE TABLE Bien_tap_vien(
	Ma_BTV VARCHAR(10) PRIMARY KEY,
	Email_BTV VARCHAR(30) NOT NULL UNIQUE,
	Ho_ten NVARCHAR(30) NOT NULL);
--1.5
CREATE TABLE Nguoi_doc(
	Ma_nguoi_doc VARCHAR(10) PRIMARY KEY,
	Email_ND VARCHAR(30) NOT NULL UNIQUE,
	Ten_hien_thi NVARCHAR(30),
	So_dien_thoai VARCHAR(11),
	Dia_chi NVARCHAR(100),
	Ngay_dang_ky DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	Ma_chuyen_muc VARCHAR(10) NOT NULL);
ALTER TABLE Nguoi_doc ADD CONSTRAINT Check_Ngay_dang_ky CHECK( Ngay_dang_ky <= CURRENT_TIMESTAMP);

--1.6
CREATE TABLE Chuyen_muc(
	Ma_chuyen_muc VARCHAR(10) PRIMARY KEY,
	Ten_chuyen_muc NVARCHAR(30) NOT NULL UNIQUE);
--1.7
CREATE TABLE Binh_luan(
	Ma_bai_viet VARCHAR(10)  NOT NULL, --PRIMARY KEY được tạo sau khi tạo bảng
	Ma_binh_luan INT IDENTITY NOT NULL, --PRIMARY KEY được tạo sau khi tạo bảng 
	Noi_dung_BL NVARCHAR(300) NOT NULL,
	Ngay_BL DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	Ma_nguoi_doc VARCHAR(10) NOT NULL);
ALTER TABLE Binh_luan ADD CONSTRAINT Check_Ngay_BL CHECK( Ngay_BL <= CURRENT_TIMESTAMP);

-- Yêu cầu 2: Tạo các ràng buộc khóa chính, khóa ngoại:
-- Yêu cầu 2a: Tạo ràng buộc khóa chính:
ALTER TABLE Binh_luan ADD CONSTRAINT PK_BL PRIMARY KEY (Ma_binh_luan, Ma_bai_viet);

-- Yêu cầu 2b: Tạo ràng buộc khóa ngoại:
ALTER TABLE Du_thao ADD CONSTRAINT FK_DT_PV FOREIGN KEY (Ma_phong_vien) REFERENCES Phong_vien(Ma_phong_vien);
ALTER TABLE Du_thao ADD CONSTRAINT FK_DT_BTV FOREIGN KEY (Ma_BTV) REFERENCES Bien_tap_vien(Ma_BTV);
ALTER TABLE Bai_viet ADD CONSTRAINT FK_BV_DT FOREIGN KEY (Ma_du_thao) REFERENCES Du_thao(Ma_du_thao);
ALTER TABLE Bai_viet ADD CONSTRAINT FK_BV_PV FOREIGN KEY (Ma_phong_vien) REFERENCES Phong_vien(Ma_phong_vien);
ALTER TABLE Bai_viet ADD CONSTRAINT FK_BV_BTV FOREIGN KEY (Ma_BTV) REFERENCES Bien_tap_vien(Ma_BTV);
ALTER TABLE Bai_viet ADD CONSTRAINT FK_BV_CM FOREIGN KEY (Ma_chuyen_muc) REFERENCES Chuyen_muc(Ma_chuyen_muc);
ALTER TABLE Phong_vien ADD CONSTRAINT FK_PV_CM FOREIGN KEY (Ma_chuyen_muc) REFERENCES Chuyen_muc(Ma_chuyen_muc);
ALTER TABLE Nguoi_doc ADD CONSTRAINT FK_ND_CM FOREIGN KEY (Ma_chuyen_muc) REFERENCES Chuyen_muc(Ma_chuyen_muc);
ALTER TABLE Binh_luan ADD CONSTRAINT FK_BL_BV FOREIGN KEY (Ma_bai_viet) REFERENCES Bai_viet(Ma_bai_viet);
ALTER TABLE Binh_luan ADD CONSTRAINT FK_BL_ND FOREIGN KEY (Ma_nguoi_doc) REFERENCES Nguoi_doc(Ma_nguoi_doc);

-- Yêu cầu 3a: Chèn dữ liệu (INSERT):
/* Dưới đây là một số dữ liệu giả định, ta chèn vào các bảng của DATABASE bằng lệnh INSERT như sau:*/ 

INSERT INTO Chuyen_muc VALUES
('CM001', N'Thời sự'),
('CM002', N'Khoa học'),
('CM003', N'Giải trí'),
('CM004', N'Số hóa'),
('CM005', N'Sức khỏe')
GO

INSERT INTO Bien_tap_vien VALUES
('BTV2595', 'thuytrinh.btv@vnexpress.net', N'Nguyễn Thị Thúy Trinh'),
('BTV1390', 'trunghieu.btv@vnexpress.net', N'Nguyễn Trung Hiếu'),
('BTV4632', 'quynhchi.btv@vnexpress.net', N'Trần Quỳnh Chi'),
('BTV3306', 'huucong.btv@vnexpress.net', N'Quách Hữu Công'),
('BTV8362', 'ductam.btv@vnexpress.net', N'Tưởng Đức Tâm')
GO

INSERT INTO Phong_vien VALUES
('PV22820', 'manhlinh.pv@vnexpress.net', N'Nguyễn Mạnh Linh', 40, 'CM001'),
('PV20785', 'quachhuucong.pv@vnexpress.net', N'Quách Hữu Công', 90, 'CM001'),
('PV83122', 'bichquyen.pv@vnexpress.net', N'Nguyễn Thị Bích Quyền', 60, 'CM002'),
('PV76705', 'nguyenhieu.pv@vnexpress.net', N'Nguyễn Trung Hiếu', 80, 'CM002'),
('PV54849', 'nguyenqkhai.pv@vnexpress.net', N'Nguyễn Quang Khải', 70, 'CM003'),
('PV54631', 'nguyenvduong.pv@vnexpress.net', N'Nguyễn Văn Dương', 55, 'CM003'),
('PV56957', 'nguyenduyminh.pv@vnexpress.net', N'Nguyễn Duy Minh', 65, 'CM004'),
('PV85078', 'nguyendinhhai.pv@vnexpress.net', N'Nguyễn Đình Hải', 70, 'CM004'),
('PV42758', 'lyngochoa.pv@vnexpress.net', N'Lý Ngọc Hoa', 100, 'CM004'),
('PV59222', 'nguyenvantoan.pv@vnexpress.net', N'Nguyễn Văn Toàn', 65, 'CM005'),
('PV69401', 'nguyenphucan.pv@vnexpress.net', N'Lợi Nguyễn Phúc Ân', 50, 'CM005'),
('PV82327', 'nguyenmanhha.pv@vnexpress.net', N'Nguyễn Mạnh Hà', 50, 'CM005')
GO

INSERT INTO Du_thao VALUES
('DT46204822', '2022-02-13 04:57:22', 3, N'Đã đăng tải', 'PV76705', 'BTV4632'),
('DT11625222', '2022-02-19 18:49:32', 2, N'Đã đăng tải', 'PV83122', 'BTV1390'),
('DT76641622', '2022-02-21 09:30:24', 1, N'Đã đăng tải', 'PV83122', 'BTV2595'),
('DT94053522', '2022-02-16 19:21:55', 1, N'Đã đăng tải', 'PV83122', 'BTV4632'),
('DT37930122', '2022-02-14 13:17:03', 1, N'Đã đăng tải', 'PV76705', 'BTV8362'),
('DT73759222', '2022-02-20 07:23:42', 0, N'Đã đăng tải', 'PV22820', 'BTV4632'),
('DT29371922', '2022-02-21 03:14:20', 2, N'Đã đăng tải', 'PV56957', 'BTV4632'),
('DT53853422', '2022-02-17 15:10:43', 0, N'Đã đăng tải', 'PV20785', 'BTV3306'),
('DT36743722', '2022-02-21 00:05:21', 3, N'Đã đăng tải', 'PV22820', 'BTV3306'),
('DT52231222', '2022-02-16 05:21:29', 0, N'Đã đăng tải', 'PV54849', 'BTV1390'),
('DT60628122', '2022-02-06 05:38:59', 0, N'Đã đăng tải', 'PV54849', 'BTV8362'),
('DT87428122', '2022-02-18 12:19:21', 1, N'Đã đăng tải', 'PV54631', 'BTV3306'),
('DT40239622', '2022-02-17 00:59:14', 3, N'Đã đăng tải', 'PV85078', 'BTV4632'),
('DT36694522', '2022-02-19 18:12:49', 3, N'Đã đăng tải', 'PV56957', 'BTV1390'),
('DT42509422', '2022-02-03 21:06:27', 2, N'Đã đăng tải', 'PV85078', 'BTV4632'),
('DT23248922', '2022-02-02 08:39:04', 1, N'Đã đăng tải', 'PV85078', 'BTV1390'),
('DT22491922', '2022-02-05 15:52:16', 0, N'Đã đăng tải', 'PV59222', 'BTV2595'),
('DT16700222', '2022-01-29 04:39:42', 2, N'Đã đăng tải', 'PV69401', 'BTV2595'),
('DT90472222', '2022-02-13 05:50:24', 0, N'Đã đăng tải', 'PV59222', 'BTV2595'),
('DT15078322', '2022-02-12 00:27:26', 1, N'Đã đăng tải', 'PV42758', 'BTV2595'),
('DT63250722', '2022-02-04 10:23:00', 1, N'Đã đăng tải', 'PV56957', 'BTV1390'),
('DT71235522', '2022-02-15 05:43:09', 2, N'Đã đăng tải', 'PV54631', 'BTV1390'),
('DT63269022', '2022-02-13 07:04:26', 3, N'Đã đăng tải', 'PV54631', 'BTV8362'),
('DT65017622', '2022-02-24 08:54:34', 0, N'Đã phê duyệt đăng', 'PV54849', 'BTV4632'),
('DT77794322', '2022-02-24 11:01:07', 2, N'Được lên lịch đăng', 'PV59222', 'BTV2595'),
('DT75512422', '2022-02-24 05:33:01', 1, N'Đã phê duyệt đăng', 'PV85078', 'BTV3306'),
('DT53418122', '2022-02-24 00:41:38', 0, N'Chờ phê duyệt', 'PV42758', 'BTV1390'),
('DT46720222', '2022-02-24 10:24:08', 2, N'Chờ phê duyệt', 'PV42758', 'BTV2595'),
('DT35662422', '2022-02-24 00:56:22', 1, N'Được lên lịch đăng', 'PV54849', 'BTV4632'),
('DT62930522', '2022-02-24 07:39:39', 1, N'Đã phê duyệt đăng', 'PV56957', 'BTV4632'),
('DT48968222', '2022-02-24 09:03:36', 1, N'Chờ phê duyệt', 'PV59222', 'BTV8362'),
('DT73536522', '2022-02-24 10:45:57', 3, N'Chờ phê duyệt', 'PV22820', 'BTV8362'),
('DT61142922', '2022-02-24 01:07:01', 2, N'Chờ phê duyệt', 'PV76705', 'BTV2595'),
('DT64480122', '2022-02-10 06:14:17', 2, N'Đang sửa', 'PV76705', 'BTV4632')
GO

INSERT INTO Bai_viet VALUES
('BV46204822', N'Báo hoa mai leo cây để trốn voi', N'Nhiếp ảnh gia Kevin Dooley chụp lại khoảnh khắc một con báo hoa mai buộc phải ẩn náu trên cảnh cây cao để thoát khỏi sự rượt đuổi của voi đực đang giận dữ tại khu bảo tồn Madikwe. Trong loạt ảnh, voi đực to lớn giương cao vòi tìm cách với cành cây nơi báo hoa mai đang bám chặt', 
	'2022-02-14 23:00:00', 'DT46204822', 'CM002', 'PV76705', 'BTV4632'),
('BV11625222', N'Tế bào nhân tạo đổi màu như bạch tuộc', N'Trong nghiên cứu mới, nhóm nhà khoa học sử dụng những màng mỏng, mềm dẻo làm từ mạng lưới polymer gồm các tinh thể lỏng, để tạo ra tế bào sắc tố nhân tạo có thể đổi màu ngay lập tức từ cận hồng ngoại đến khả kiến và cực tím theo yêu cầu. Các màng này được phủ lên những lỗ nhỏ sắp xếp thành mạng lưới, mỗi lỗ có thể được bơm đến áp suất nhất định. Khi lỗ được bơm phồng, màng bị kéo căng, giảm độ dày và thay đổi màu sắc.', 
	'2022-02-21 20:00:00', 'DT11625222', 'CM002', 'PV83122', 'BTV1390'),
('BV76641622', N'Lớp phủ ngăn kính bám sương mù', N'Giống như các lớp phủ chống sương mù khác, lớp phủ này hoạt động bằng cách khiến các giọt nước tí hon đọng trên kính lan ra thành một màng đồng nhất có thể dễ dàng nhìn xuyên qua. Nó thực hiện điều này chỉ trong vòng 93 mili giây sau khi giọt nước chạm vào màng', 
	'2022-02-23 19:00:00', 'DT76641622', 'CM002', 'PV83122', 'BTV2595'),
('BV94053522', N'Biến bã cà phê thành sản phẩm làm đẹp', N'Công ty Upcircle ở London đang tận dụng bã cà phê bỏ đi để sản xuất kem tẩy da chết, mang lại giá trị kinh tế từ rác thải. Quá trình sản xuất sản phẩm tẩy da chết của Upcircle rất đơn giản: bã cà phê được trộn với đường và tinh dầu, sau đó đánh bông hỗn hợp với bơ hạt mỡ và thêm chất bảo quản tự nhiên. Sản phẩm cuối cùng được đổ vào các lọ thủy tinh và bán ra thị trường.', 
	'2022-02-20 19:00:00', 'DT94053522', 'CM002', 'PV83122', 'BTV4632'),
('BV37930122', N'Phát hiện tiểu hành tinh có ba mặt trăng', N'Electra 130 nằm trong vành đai tiểu hành tinh chính giữa sao Mộc và sao Hỏa, được phát hiện vào ngày 17/2/1873 bởi nhà thiên văn học Christian Peters tại Đài quan sát Litchfield ở New York, nhưng mãi đến năm 2003, sau 130 năm, các nhà khoa học mới tìm thấy mặt trăng đầu tiên của thiên thể và đặt tên cho nó là S/2003. Tuy nhiên, trong một nghiên cứu mới xuất bản trên tạp chí Astrophysical
	Journal Letters hôm 8/2, các nhà nghiên cứu từ Đài thiên văn phía nam châu Âu (ESO) đã xác nhận sự tồn tại của mặt trăng thứ ba trên quỹ đạo của Elektra 130, biến nó trở thành tiểu hành tinh đầu tiên được biết đến trong hệ Mặt Trời	có ba vệ tinh tự nhiên.', 
	'2022-02-18 19:00:00', 'DT37930122', 'CM002', 'PV76705', 'BTV8362'),
('BV73759222', N'Việt Nam nối lại 20 đường bay quốc tế', N'So với thời điểm trước dịch (mùa Đông năm 2019), còn 8 quốc gia và vùng lãnh thổ chưa nối lại đường bay là Brunei, Ấn Độ, Indonesia, Myanma, Macao, Phần Lan, Italy, Thụy Sĩ. Theo Bộ Giao thông Vận tải, tần suất các chuyến bay quốc tế đi/đến Việt Nam là 370 chuyến mỗi chiều hàng tuần, tương đương 53 chuyến bay mỗi ngày. Trong khi tần suất khai thác các đường bay quốc tế thời điểm trước dịch là 4.185 
	chuyến mỗi chiều hàng tuần, tương đương 598 chuyến mỗi ngày. Như vậy, tần suất các chuyến bay chặng quốc tế mới đạt khoảng 10% so với trước đây.',
	'2022-02-22 10:06:00', 'DT73759222', 'CM001', 'PV22820', 'BTV4632'),
('BV29371922', N'Lý do chưa triển khai hộ chiếu vaccine', N'Cục Công nghệ thông tin - Bộ Y tế cho biết đã làm việc với các cơ quan của Bộ Thông tin và Truyền thông, đơn vị cung cấp dịch vụ để cùng đánh giá chức năng ký số. "Hiện chức năng chưa đáp ứng yêu cầu nên chưa thể triển khai thử nghiệm". Theo Bộ Y tế, giải pháp ký số được đưa ra xem xét còn tồn tại một số vấn đề, như chức năng ký số phải ký được cả dữ liệu định dạng json, trong khi hiện mới ký được định dạng tệp pdf. 
	Quy trình ký số cần cho phép tỉnh thành trực thuộc Trung ương chỉ định đơn vị ký tập trung (Sở Y tế hoặc Trung tâm Kiểm soát bệnh tật tỉnh) hoặc các cơ sở tiêm chủng ký tùy theo khả năng, tình hình thực tế ở mỗi địa phương. Ngoài ra, chữ ký số phải sử dụng được các dịch vụ của nhà cung cấp khác nhau.', 
	'2022-02-22 18:45:00', 'DT29371922', 'CM004', 'PV56957', 'BTV4632'),
('BV53853422', N'Chiều nay không khí lạnh tràn về miền Bắc', N'Trung tâm Dự báo Khí tượng Thủy văn quốc gia cho biết, không khí lạnh còn kết hợp với hội tụ gió trên cao gây mưa cho Bắc Bộ từ chiều 18/2 đến ngày 21/2. Trong đó vùng núi và trung du có mưa vừa 30-50 mm/đợt, có nơi mưa rất to trên 130 mm/đợt', 
	'2022-02-18 09:45:00', 'DT53853422', 'CM001', 'PV20785', 'BTV3306'),
('BV36743722', N'Hà Nội lấy ý kiến người dân về kiến trúc cầu Trần Hưng Đạo', N'UBND TP Hà Nội vừa đồng ý với đề xuất của Ban Quản lý dự án đầu tư xây dựng công trình giao thông về việc tổ chức triển lãm kết quả thi tuyển và tuyển chọn phương án kiến trúc cầu Trần Hưng Đạo tại 93 Đinh Tiên Hoàng.
	Phương án 1, cầu Extrados bê tông cốt thép (dầm - cáp hỗn hợp) có kết cấu chính là 5 trụ tháp kết hợp với dây văng. Trong đó, trụ chính giữa thiết kế tạo điểm nhấn, 4 trụ hai bên đối xứng trụ chính.
	Phương án 2, cầu vòm thép kết hợp dây văng gồm 3 vòm chính mềm mại tương phản với 4 tháp nghiêng hai bên tạo thành sự thống nhất giữa các mặt đối lập, như tinh thần hài hòa âm dương.
	Phương án 3 là cầu dầm hộp bê tông cốt thép dự ứng lực kết hợp trụ tháp. Kiến trúc mang phong cách cổ điển, kết nối trục cảnh quan đường Trần Hưng Đạo với các công trình kiến trúc kiểu Pháp và khu vực phát triển mới bắc sông Hồng.', 
	'2022-02-23 12:13:00', 'DT36743722', 'CM001', 'PV22820', 'BTV3306'),
('BV52231222', N'Hàng chục nghìn sách giảm giá ở Hội sách xuyên Việt', N'Hội sách xuyên Việt 2022 chủ đề Khai Xuân mãnh hổ - Bùng nổ sách hay. Sự kiện giới thiệu tác phẩm của sáu đơn vị: Cửa hàng sách Nhà xuất bản Trẻ, Thái Hà Books, Nhã Nam, Minh Long, Đinh Tị và Saigon Books. Ngoài các đầu sách đồng giá 5.000-30.000 đồng, các ấn phẩm còn giảm giá 25%-35%, từ 12h đến 13h', 
	'2022-02-17 21:13:00', 'DT52231222', 'CM003', 'PV54849', 'BTV1390'),
('BV60628122', N'Tết Hà Thành đầu thế kỷ 20', N'Không thể so sánh Tết với bất cứ lễ hội nào của người châu Âu. Nhưng ngay cả những nước phương Tây ít am hiểu nhất cũng lý giải được niềm hy vọng sục sôi bao trùm thời điểm này, cũng như nỗi hoan hỷ mà người ta cố gắng kìm nén, nhưng cuối cùng lại thủ tiêu mọi thứ ngăn giữ. Ngay cả tại các nhiệm sở, nơi những viên thư ký đã giữ được lâu nhất vẻ bình thản cần thấy của nhân viên mẫn cán, thì tâm trạng những ngày 
	giáp Tết cũng "thổi" đến như luồng gió điên rồ. Điều này trở nên "bức bối" khủng khiếp khi những con người kém may mắn ấy phải nén chịu để mà sắp xếp ngôn từ theo đúng quy tắc Pháp ngữ, hoặc quy định sổ sách kế toán, trong lúc đầu óc thì bộn bề lo lắng, nào thì những món nợ phải trả, nào quà tặng cha mẹ, bạn bè phải tiếp đón, cùng vô vàn mối quan tâm cá nhân khác nữa.',
	'2022-02-08 00:05:00', 'DT60628122', 'CM003', 'PV54849', 'BTV8362'),
('BV87428122', N'Mặc ấm mà vẫn đẹp ngày rét', N'Trên Vogue, các chuyên gia khuyên khi nhiệt độ môi trường xuống thấp, bạn nên mặc nhiều lớp áo ôm sát cơ thể và có độ mỏng vừa phải. Việc mặc áo dày không bó sát tạo ra các khoảng hở giúp gió len lỏi vào trong, khiến cơ thể mất nhiệt. Để tạo nên vẻ thẩm mỹ, bạn nên mặc quần áo giữ nhiệt trong cùng, sau đó đến áo len ôm sát, thêm sơ mi dài tay, rồi tới cardigan hoặc blazer dạ. Ngoài cùng, bạn có thể chọn măng tô 
	hoặc áo khoác phao. Bộ đồ này có thể đi cùng mọi loại quần dài như jeans, quần vải baggy... Với những ngày vừa rét vừa mưa, bạn nên chọn áo khoác phao có độ dày để giữ ấm với nhiều kiểu phối đa dạng. Khi tiết trời khô ráo, bạn có thể chuyển sang áo khoác lông. Có nhiều loại lông giữ ấm cơ thể hiệu quả như lông vũ, lông cừu. Các cô gái có thể chọn áo khoác lông trắng diện cùng quần skinny jeans, bốt cao tới gối bằng da lộn hoặc bốt cổ ngắn là đủ sành điệu.', 
	'2022-02-21 12:01:00', 'DT87428122', 'CM003', 'PV54631', 'BTV3306'),
('BV40239622', N'Trung Quốc cảnh báo lừa đảo trong vũ trụ ảo', N'Theo CCTV Finance, không ít game gắn mác vũ trụ ảo thực chất chỉ núp bóng công nghệ blockchain. Nhiều mô hình lấy tiền của người tham gia sau để trả cho người trước. 
	Những hoạt động liên quan đến tiền điện tử vẫn được xem là trái phép tại Trung Quốc, do đó những dự án game như thế có thể sụp đổ bất cứ lúc nào. Không ít trường hợp thổi phồng giá trị của bất động sản ảo trong metaverse để lôi kéo 
	người dùng mới. Nhiều dự án còn dụ dỗ người chơi mua tiền mã hóa, sau đó thu lợi bằng cách thao túng giá và chặn rút tiền. CBIRC khuyến khích người dân báo với chính quyền nếu phát hiện những trường hợp lừa đảo như trên.', 
	'2022-02-21 07:00:00', 'DT40239622', 'CM004', 'PV85078', 'BTV4632'),
('BV36694522', N'Ba tuyến cáp quang biển cùng gặp sự cố', N'Sự cố với IA diễn ra trong giai đoạn hai tuyến cáp quang biển khác là AAG và APG vẫn chưa được xử lý. Theo một nguồn tin trong ngành, APG gặp sự cố trên phân đoạn cách Hong Kong 
	khoảng 125 km từ ngày 13/12 nhưng dự kiến quá trình khắc phục chỉ hoàn thành vào ngày 24/2', 
	'2022-02-23 06:06:00', 'DT36694522', 'CM004', 'PV56957', 'BTV1390'),
('BV42509422', N'Sóng gió đang ập đến với Facebook', N'Trong báo cáo tài chính quý IV/2021, Mark Zuckerberg, CEO Meta, thừa nhận nhiều thách thức đang bủa vây Facebook. Lần đầu tiên lượng người dùng Facebook hàng ngày trung bình trong 
	một quý bị giảm kể từ 2004. Theo Financial Times, tin xấu khiến cổ phiếu Meta sụt giảm nặng nề. Hôm 3/2, giá cổ phiếu của công ty này giảm 27%, khiến vốn hoá bốc hơi 230 tỷ USD - mức chưa từng có tại phố Wall hay Thung lũng Silicon.', 
	'2022-02-05 10:06:00', 'DT42509422', 'CM004', 'PV85078', 'BTV4632'),
('BV23248922', N'Google AI tự viết code như lập trình viên', N'AlphaCode, công cụ AI do DeepMind của Google sản xuất, có thể tự lập trình với ""chuyên môn của một lập trình viên bình thường"".
	DeepMind đã kiểm tra năng lực của AlphaCode bằng cách cho công cụ AI này tham dự các cuộc thi viết mã do Codeforces - nền tảng chuyên đào tạo kỹ năng của hàng chục nghìn lập trình viên phần mềm trên khắp thế giới - tổ chức. 
	Trình độ của AlphaCode được đánh giá ""bình thường"" ở hiện tại, nhưng là bước tiến lớn trong việc để máy móc tự tư duy lập trình.', 
	'2022-02-04 08:00:00', 'DT23248922', 'CM004', 'PV85078', 'BTV1390'),
('BV22491922', N'Rau diếp cá chữa viêm họng', N'Trong Đông y, toàn bộ cây diếp cá được dùng để làm thuốc trị cảm cúm và	phế cầu khuẩn, giải độc, thanh nhiệt, giảm đau, trị ho, giảm đau họng hiệu quả. Lương y Bùi Đắc Sáng, Viện Hàn lâm Khoa học và Công nghệ, Hội Đông y Việt Nam, chia sẻ các bài thuốc từ lá rau trong vườn để chữa khỏi các triệu chứng khó chịu này', 
	'2022-02-08 09:00:00', 'DT22491922', 'CM005', 'PV59222', 'BTV2595'),
('BV16700222', N'Ăn uống chống Covid cho trẻ chưa tiêm vaccine', N'Tiến sĩ, bác sĩ Nguyễn Thị Thu Hậu (Trưởng Khoa Dinh dưỡng, Bệnh viện Nhi đồng 2) cho biết người khỏe mạnh, có sức đề kháng tốt thường ít bị lây nhiễm hơn và nếu nhiễm virus thì biểu
	hiện bệnh cũng nhẹ hơn, nhanh hồi phục hơn những người có sức khỏe yếu, sức đề kháng kém, có bệnh nền. Dinh dưỡng trong phòng chống Covid-19 cần hợp lý cho từng nhóm lứa tuổi, theo bệnh nền nếu có với chế độ ăn đa dạng giúp cơ thể khỏe mạnh, 
	tăng cường miễn dịch chứ không có một loại thực phẩm riêng biệt nào có tác dụng ngừa Covid-19.', 
	'2022-02-03 08:30:00', 'DT16700222', 'CM005', 'PV69401', 'BTV2595'),
('BV90472222', N'Chạy bộ có thể gây mòn răng?', N'Mòn răng là tình trạng xảy ra khi men răng bị axit tác động và không thể phục hồi. Theo các nhà khoa học, có rất nhiều lý do gây ra tình trạng này. Trong đó, việc hoạt động thể chất như chơi 
	thể thao, chạy bộ cũng có thể khiến răng bị mòn. Nguyên nhân đầu tiên liên quan đến chất lượng và số lượng nước bọt. Nước bọt có tác dụng trung hòa độ axit và cuốn trôi vi khuẩn, tạo pH kiềm, hỗ trợ tái khoáng men răng. Trong trường hợp 
	chạy bộ liên tục, nhất là trong tiết nắng nóng, cơ thể sẽ mất nước làm lượng nước bọt giảm đi. Từ đó, răng sẽ không được bảo vệ tốt nhất.', 
	'2022-02-16 14:00:00', 'DT90472222', 'CM005', 'PV59222', 'BTV2595'),
('BV15078322', N'Ổ SSD có thể tăng giá đột biến', N'Western Digital bị hỏng ít nhất 6,5 tỷ gigabyte dung lượng ổ cứng flash do các vấn đề về ô nhiễm tại cơ sở sản xuất NAND của mình. Hiện Western Digital và Kioxia (trước đây là Toshiba)là liên minh sản xuất chip nhớ flash lớn nhất thế giới, chiếm 30% thị trường với nhiều khách hàng lớn như Apple. Liên minh này cũng chủ yếu cung cấp ổ cứng SSD và eMMC cho PC.
	Vì vậy theo hãng nghiên cứu thị trường TrendForce, việc Western Digital phải tiêu huỷ chip nhớ có thể làm ổ SSD tăng giá 10%. Từ đó, giá bán của PC có thể tiếp tục tăng thêm nữa, bên cạnh việc tác động của tình trạng thiếu hụt chip xử lý và GPU như hiện nay.', 
	'2022-02-14 10:05:00', 'DT15078322', 'CM004', 'PV42758', 'BTV2595'),
('BV63250722', N'Foxconn thưởng lớn tìm người làm iPhone sau Tết', N'Tình trạng thiếu công nhân lắp ráp iPhone, iPad khiến nhà máy Foxconn ở Trung Quốc tuyển dụng quy mô lớn với mức thưởng cao cho nhân viên mới. Theo Sina, nhà máy Foxconn Trịnh Châu chuyên lắp ráp iPhone đang có nhu cầu tuyển thêm nhân công sau kỳ nghỉ khi tăng mức thưởng cho nhân viên mới	từ 6.000 nhân dân tệ (21,4 triệu đồng) lên 8.000 nhân dân tệ (28,5 triệu đồng). Trong khi đó, Foxconn Thành Đô, cơ sở 
	sản xuất iPad lớn nhất thế giới, cũng đưa ra mức đãi ngộ cao. Những người cam kết làm việc nhiều hơn 90 ngày có thể nhận khoản tiền thưởng 10.000 nhân dân tệ (35,6 triệu đồng). Lương theo giờ của nhà máy cũng tăng lên 32 nhân dân tệ (114.000 đồng), cao hơn mức bình thường là 25 nhân dân tệ (89.000 đồng).', 
	'2022-02-09 23:28:00', 'DT63250722', 'CM004', 'PV56957', 'BTV1390'),
('BV71235522', N'Cơn đau thắt ngực báo hiệu nhồi máu cơ tim', N'Nhồi máu cơ tim cấp thường gặp ở những bệnh nhân tuổi trung niên, cao tuổi, có các bệnh lý kết hợp như tăng huyết áp, tiểu đường, rối loạn mỡ máu, ít hoạt động thể dục thể lực... Nếu không được cấp cứu can thiệp kịp thời bệnh nhân sẽ biến chứng nguy hiểm như rối loạn nhịp tim, suy tim cấp, tai biến do tắc mạch, vỡ tim, đột tử. Triệu chứng điển hình của nhồi máu cơ tim là đau nặng ngực, đau giữa ngực, sau xương ức hoặc 
	hơi lệch trái, cảm giác nặng, bóp nghẹt, siết chặt, đè, có khi lan ra tay trái, lên cằm xuống bụng vùng trên rốn. Thời gian đau ngực trong 20-30 phút hoặc dài hơn. Người bệnh có thể kèm vã mồ hôi, khó thở và bất tỉnh. Ngoài ra, có người không đau ngực mà đau bụng vùng trên rốn, đau sau lưng.', 
	'2022-02-18 00:28:00', 'DT71235522', 'CM003', 'PV54631', 'BTV1390'),
('BV63269022', N'Xử trí khi ngạt mũi', N'Khi bị ngạt mũi, bạn không nên tự điều trị, nhất là sử dụng các thuốc co mạch kéo dài vì đây là nguyên nhân gây nghiện thuốc nhỏ mũi, gây xơ cứng cuốn dưới không hồi phục... Với trẻ em dưới 2 tuổi, tuyệt đối không tự sử dụng thuốc nhỏ mũi chống ngạt do một số thuốc có nồng độ không phù hợp gây nguy hiểm hay tinh dầu. Thay vào đó, bạn nên đi khám để được bác sĩ hướng dẫn cách sử dụng thuốc nhỏ mũi an toàn và hiệu quả. 
	Trường hợp mắc bệnh lý nguy hiểm, bạn được xử trí kịp thời như mổ lấy khối u, trong trường hợp u ác tính bên cạnh phẫu thuật còn cần phối hợp hoá chất và xạ trị. Hạn chế di căn của các khối u ác tính sang các bộ phận kế cận như di căn não,	xương, tai và di căn toàn thân; chảy dịch não tủy sau các chấn thương vùng mũi đi kèm.', 
	'2022-02-16 11:38:00', 'DT63269022', 'CM003', 'PV54631', 'BTV8362');
GO

INSERT INTO Nguoi_doc VALUES  
('ND68069916', 'quytpfx14208@gmail.com', N'Trần Phú Quý', '0360762969', N'43B Trần Huỳnh, phường 7, Tp. Bạc Liêu, Bạc Liêu', '2016-11-15', 'CM005'),
('ND55698117', 'giangvhfx13288@gmail.com', N'Võ Hoàng Giang', '0316914226', N'8 Kim Đồng, P. Giáp Bát, Quận Hoàng Mai, Hà Nội', '2017-10-15', 'CM003'),
('ND88982219', 'phuongnhhfx12447@gmail.com', N'Nguyễn Phương', '0315086606', N'9 Nguyễn Trãi, phường 2, Tx. Gò Công, Tiền Giang', '2019-05-08', 'CM001'),
('ND58389715', 'giaunnFX13469@gmail.com', N'Nguyễn Ngọc Giàu', '0888716150', N'79 Lý Thường Kiệt, phường 5, Tp. Mỹ Tho, Tiền Giang', '2015-07-22', 'CM003'),
('ND83652220', 'sybvfx13618@gmail.com', N'Bùi Văn Sỹ', '0854295417', N'Liền kề 25 KĐT Bắc Hà, Phố An Hòa, Quận Hà Đông, Hà Nội', '2020-05-03', 'CM002'),
('ND79620915', 'hieuhvFX14188@gmail.com', N'Hoàng Văn Hiếu', '0749172114', N'42 Lê Thành Phương, phường Phương Sài, Tp. Nha Trang, Khánh Hòa', '2015-10-29', 'CM002'),
('ND84499017', 'yenntFX15090@gmail.com', N'Nguyễn Thị Yến', '0675727230', N'50 Nguyễn Huệ, P.An Thạnh, Tx. Hồng Ngự, Đồng Tháp', '2017-07-10', 'CM005'),
('ND96008317', 'huydqfx14879@gmail.com', N'Đậu Quang Huy', '', N'63 tổ 2 thị trấn An Dương, Huyện An Dương, Hải Phòng', '2017-03-20', 'CM005'),
('ND62767016', 'nhanpdFX05810@gmail.com', N'Phùng Đức Nhân', '0656179221', N'156 Lương Ngọc Quyến, phường Hoàng Văn Thụ, Thành phố Thái Nguyên', '2016-06-29', 'CM005'),
('ND98929518', 'nhanpqFX14822@gmail.com', N'Phùng Quang Nhân', '0363859491', N'248 Phố Mới, thị trấn Chờ, huyện Yên Phong, Bắc Ninh', '2018-01-20', 'CM005'),
('ND21044315', 'nhantdFX110805@gmail.com', N'Trần Đức Nhân', '0351851539', N'Số 9/12 đường Đồng Khởi, Tân Hiệp, Tp. Biên Hòa, Đồng Nai', '2015-11-06', 'CM002'),
('ND49364919', 'daoltbfx15051@gmail.com', N'Lê Thị Bích Đào', '0710274123', N'Số 83 Đỗ Đăng Tuyển, thị trấn Ái Nghĩa, huyện Đại Lộc, Quảng Nam', '2019-06-10', 'CM002'),
('ND42331818', 'trinmfx15581@gmail.com', N'Nguyễn Minh Trí', '0799650192', N'Số 2 TDP Quyết Tiến, thị trấn Sơn Dương, Huyện Sơn Dương, Tuyên Quang', '2018-04-26', 'CM003'),
('ND87276719', 'hailvnfx14964@gmail.com', N'Lê Văn Ngọc Hải', '0679027590', N'Số 347 Khu Phố Ngã Ba, thị trấn Kiên Lương. huyện Kiên Lương, Kiên Giang', '2019-12-24', 'CM001'),
('ND56058920', 'nghiapdfx15202@gmail.com', N'Phạm Đại Nghĩa', '0978235802', N'227 Khu 2 thị trấn Hậu Lộc, Huyện Hậu Lộc, Thanh Hóa', '2020-12-17', 'CM005'),
('ND41151521', 'anhptfx15241@gmail.com', N'Phạm Trường Anh', '0850341386', N'34 Trần Hưng Đạo, Thị xã Quảng Yên, Quảng Ninh', '2021-02-22', 'CM005'),
('ND90153121', 'vuongnvfx15456@gmail.com', N'Nguyễn Vương', '0347154055', N'250 QL1A, TT.Hộ Phòng, Huyện Giá Rai, Bạc Liêu', '2021-01-01', 'CM001'),
('ND61278617', 'hanmfx13850@gmail.com', N'Nguyễn Mạnh Hà', '0755697416', N'130 khu 6 TT.Diêm Điền, huyện Thái Thụy, Thái Bình', '2017-01-13', 'CM005'),
('ND12187617', 'khanhptfx15310@gmail.com', N'Phạm Khánh', '0310196712', '', '2017-04-02', 'CM004'),
('ND76440121', 'quynhpbfx09832@gmail.com', N'Phạm Bá Quỳnh', '0916169158','', '2021-07-29', 'CM004'),
('ND22640319', 'vutvfx11869@gmail.com', N'Trần Văn Vũ', '0734103099', N'21 Lý Tự Trọng, TP Móng Cái, Quảng Ninh', '2019-11-01', 'CM001'),
('ND62676315', 'hoangthfx15592@gmail.com', N'Trần Hữu Hoàng', '0921682229', N'79B Đường TC4, KP Mỹ Phước 2, Tx. Bến Cát, Bình Dương', '2015-10-08', 'CM002'),
('ND38119919', 'duongttfx15596@gmail.com', N'Trần Thùy Dương', '0725084478', N'118 Mậu Thân, phường An Nghiệp, Cần Thơ', '2019-03-04', 'CM001'),
('ND52003021', 'lynhce140219@gmail.edu.vn', N'Nguyễn Hữu Lý', '0982553992', N'182-184 Đường 2 tháng 9, P. Hòa Cường Bắc, Quận Hải Châu, Đà Nẵng', '2021-08-04', 'CM003'),
('ND58995717', 'khanhhddfx14223@gmail.com', N'Huỳnh Khánh', '0616414858', N'Số 31 Đại Đồng, thị trấn Đại Nghĩa, huyện Mỹ Đức, Huyện Mỹ Đức, Hà Nội', '2017-12-06', 'CM001'),
('ND94242717', 'nhatdbfx09444@gmail.com', N'Dương Bá Nhật', '', N'256 Ngô Gia Tự, P. Đức Giang, Quận Long Biên, Hà Nội', '2017-03-11', 'CM002'),
('ND70848421', 'tuanvqfx15145@gmail.com', N'Vương Q.Tuấn', '0316653388', N'263 Quang Trung, tổ 9 Trung Sơn, Tam Điệp, Tp. Tam Điệp, TP Hồ Chí Minh', '2021-05-21', 'CM004')
GO

INSERT INTO Binh_luan([Ma_bai_viet],[Noi_dung_BL],[Ngay_BL],[Ma_nguoi_doc]) VALUES
('BV36694522', N'Hy vọng các nhà mạng giảm tiền thuê bao cho khách hàng khi sự cố triền miên thế này.', '2022-02-24 03:00:30', 'ND94242717'),
('BV36694522', N'Mấy hôm nay buổi tối không vào được mạng. Cứ tưởng máy tính mình bị làm sao', '2022-02-24 02:44:56', 'ND62676315'),
('BV87428122', N'nói là mặc nhiều lớp mỏng ấm hơn nhưng chỉ hợp đi ô tô, đi bộ, chứ đi xe máy như ở HN thì ko thể thiếu áo phao dày, áo lông thì bắt bụi lại gặp trời mưa thì thôi', '2022-02-24 02:31:23', 'ND76440121'),
('BV23248922', N'Mỹ vẫn chiếm ưu thế rất lớn trọg lĩnh vực AI', '2022-02-23 23:58:24', 'ND84499017'),
('BV63269022', N'Lúc ngạt em chỉ biết một kế là há mồm ra thở', '2022-02-23 22:24:40', 'ND61278617'),
('BV36694522', N'Điệp khúc này nghe quen quen', '2022-02-23 22:18:32', 'ND87276719'),
('BV29371922', N'Nên quy định số đó là số điện thoại', '2022-02-23 22:08:09', 'ND87276719'),
('BV63269022', N'tập thể dục và hít thở kiểu như tập thể hình ! hít nhiều vào và thở ra hết lại hít vào thở ra liên tục làm vài phút là hết nghẹt', '2022-02-23 21:27:19', 'ND42331818'),
('BV36694522', N'Ra ngoài nhiều thì xăng tăng tốn kém, về nhà thì internet chậm lỗi. Nan giải đây, anh em nói xem nên ra đường hay nên ở nhà', '2022-02-23 19:27:19', 'ND21044315'),
('BV63269022', N'Nếu thấy người khác bị viêm mũi, ho thì bạn nên giữ khoảng cách, đeo khẩu trang như phòng covid', '2022-02-23 19:19:45', 'ND56058920'),
('BV53853422', N'rét nàng Bân, vừa lạnh vừa ẩm', '2022-02-23 17:12:04', 'ND41151521'),
('BV36694522', N'Một năm mất 10 tháng sửa chữa đứt cáp.', '2022-02-23 11:38:40', 'ND96008317'),
('BV36694522', N'Có cái cáp một năm đứt ko biết bao nhiêu lần, mà chưa một lần được hoàn phí sử dụng?', '2022-02-23 11:29:43', 'ND42331818'),
('BV63269022', N'Mỗi khi nghẹt mũi mình thường xông mũi bằng viên tinh dầu tràm mua ở tiệm thuốc tây, mình thấy đỡ hơn rất nhiều', '2022-02-23 06:06:18', 'ND96008317'),
('BV73759222', N'Du lịch dần quay lại rồi. Niềm vui của bao người', '2022-02-23 03:31:47', 'ND55698117'),
('BV42509422', N'Facebook quá nhiều quảng cáo, dù liên tục có những bản cập nhật nhưng tất cả cũng chỉ để tối ưu việc quảng cáo', '2022-02-23 01:07:17', 'ND87276719'),
('BV87428122', N'Người đẹp thì mặc gì cũng đẹp', '2022-02-22 19:35:33', 'ND42331818'),
('BV36694522', N'Chờ dự án internet vệ tinh hoàn thành thì không còn lo đứt cáp nữa!', '2022-02-22 00:37:34', 'ND87276719'),
('BV73759222', N'Mở lại là đúng', '2022-02-22 00:05:59', 'ND90153121'),
('BV29371922', N'Chắc tại thủ tục còn quá rườm rà', '2022-02-21 10:09:37', 'ND76440121'),
('BV23248922', N'Rồi 1 thời gian nữa lập trình viên bị AI Code cướp việc', '2022-02-21 02:26:29', 'ND88982219'),
('BV42509422', N'Nói thật không thích facebook nhưng vẫn còn hơn tiktok', '2022-02-19 12:59:13', 'ND96008317'),
('BV29371922', N'Kỹ thuật sốVN cũng mới chỉ mới thời kỳ bắt đầu, còn phải học nữa học mãi', '2022-02-19 08:19:14', 'ND79620915'),
('BV22491922', N'Biết là rau diếp cá rất tốt cho sức khỏe nhưng mình không thể ăn được nó', '2022-02-18 23:10:25', 'ND52003021'),
('BV23248922', N'Nói là AI chứ thực ra nó chỉ là cái thư viện tự động. Việc thay thế thì không thể vì nó không có khả năng tư duy.', '2022-02-17 22:18:48', 'ND41151521'),
('BV15078322', N'Thật ra là Nhật họ có tâm, thấy ô nhiễm là huỷ lô hàng', '2022-02-17 08:29:23', 'ND88982219'),
('BV42509422', N'Tôi mong nó sập', '2022-02-15 02:00:47', 'ND49364919'),
('BV23248922', N'Một thời gian nữa thì robot sẽ tự tạo ra robot con người chả phải làm gì nữa', '2022-02-08 09:19:15', 'ND49364919'),
('BV87428122', N'Đối với những người thích đẹp thì thời trang fang thời tiết', '2022-02-06 13:53:46', 'ND52003021'),
('BV73759222', N'Hoan hô một quyết định sáng suốt. Hãy dẹp bỏ lo toan và vui sống!', '2022-02-06 04:48:39', 'ND68069916'),
('BV63269022', N'mình không phải viêm xoang mà kiểu dị ứng, cứ đụng nước hoặc lạnh lạnh hoặc bậc quạt lâu chút là xụt xịt', '2022-02-06 00:24:28', 'ND41151521'),
('BV29371922', N'hãy dùng PC-Covid để cung cấp hộ chiếu vaccine một cách tự động', '2022-02-05 16:37:18', 'ND41151521'),
('BV53853422', N'Chả bù Sài Gòn mấy ngày nay toàn nắng nóng 36-38 độ, có ai cho xin 1 tí lạnh của Miền Bắc vào đi', '2022-02-05 09:00:30', 'ND76440121'),
('BV53853422', N'vậy trẻ nhỏ cấp 1 nên ra quyết định nghỉ học luôn ngày 21/2 đi thôi', '2022-02-04 15:08:22', 'ND22640319'),
('BV94053522', N'Những tiệm spa ở Việt Nam đã dùng bã cà phê tẩy tế bào chết nhiều năm nay rồi.', '2022-02-04 10:40:59', 'ND98929518');
GO

--Yêu cầu 3b: Cập nhật dữ liệu (UPDATE):
/*Do biên tập viên Thúy Trinh bị cách ly Covid19 trong 2 tuần, bài dự thảo có mã 'DT46720222' được chuyển sang 
cho biên tập viên Quỳnh Chi phụ trách, ta thực hiện lệnh UPDATE biên tập viên như sau: */

UPDATE Du_thao
SET Ma_BTV = 'BTV4632'
WHERE Ma_du_thao = 'DT46720222';
GO

--Yêu cầu 3c: Xóa dữ liệu (DELETE):
/*Bài dự thảo có mã 'DT64480122' được biên tập viên yêu cầu chỉnh sửa, nhưng phóng viên để quá thời hạn nộp bài nên bài dự thảo
sẽ bị xóa khỏi cơ sở dữ liệu, ta thực hiện lệnh DELETE bài dự thảo như sau: */
DELETE FROM Du_thao
WHERE Ma_du_thao = 'DT64480122';
GO

--Yêu cầu 4: Thực hiện tạo TRIGGER
/* Khi BTV đăng một bài viết mới từ bản dự thảo hoàn chỉnh, Biên tập viên chỉ cần điền các thông tin
Mã bài viết, Tên bài, Nội dung và Mã dự thảo của bài viết lên DATABASE, các thông tin còn lại như:
	1. Mã phóng viên tự động UPDATE theo thông tin từ bản dự thảo có trước
	2. Mã biên tập tự động UPDATE theo thông tin từ bản dự thảo có trước
	3. Thời gian đăng bài sẽ tự động UPDATE theo giờ hiện tại
	4. Mã chuyên mục tự động UPDATE theo mã chuyên mục mà phóng viên đăng ký
	5. Trạng thái bài dự thảo sẽ UPDATE thành 'Đã đăng tải'		*/

CREATE TRIGGER InsertBV_UpdateBV_UpdateDT
    ON Bai_viet AFTER INSERT AS
    BEGIN
		-- (1) UPDATE Ma_phong_vien 
		UPDATE Bai_viet SET Ma_phong_vien = 
			(SELECT Du_thao.Ma_phong_vien FROM Du_thao join inserted ON Du_thao.Ma_du_thao = inserted.Ma_du_thao)
		FROM Bai_viet join inserted ON Bai_viet.Ma_bai_viet = inserted.Ma_bai_viet;
		-- (2) UPDATE Ma_BTV 
		UPDATE Bai_viet SET Ma_BTV = 
			(SELECT Du_thao.Ma_BTV FROM Du_thao join inserted ON Du_thao.Ma_du_thao = inserted.Ma_du_thao)
		FROM Bai_viet join inserted ON Bai_viet.Ma_bai_viet = inserted.Ma_bai_viet;
		-- (3) UPDATE TG_dang_bai 
		UPDATE Bai_viet SET TG_dang_bai = CURRENT_TIMESTAMP
		FROM Bai_viet join inserted ON Bai_viet.Ma_bai_viet = inserted.Ma_bai_viet;
		-- (4) UPDATE mã chuyên mục 
		UPDATE Bai_viet SET Ma_chuyen_muc = 
			(SELECT Phong_vien.Ma_chuyen_muc FROM Phong_vien WHERE Phong_vien.Ma_phong_vien =   --SELECT Ma_CM tu bang PV
					(SELECT Du_thao.Ma_phong_vien FROM Du_thao join inserted ON Du_thao.Ma_du_thao = inserted.Ma_du_thao)) -- SELECT Ma_PV
		FROM Bai_viet join inserted ON Bai_viet.Ma_bai_viet = inserted.Ma_bai_viet;
		-- (5) UPDATE Trang_thai Du_thao 
		UPDATE Du_thao SET Trang_thai = N'Đã đăng tải'
		FROM Du_thao join inserted ON Du_thao.Ma_du_thao = inserted.Ma_du_thao;
	END
GO
-- VD Bài dự thảo 'DT48968222' được đăng tải với mã bài viết 'BV48968222'
SELECT * FROM Bai_viet WHERE Ma_bai_viet = 'BV48968222'		-- Trước khi đăng tải
SELECT * FROM Du_thao WHERE Ma_du_thao = 'DT48968222'		-- Trước khi đăng tải
GO
BEGIN TRANSACTION											-- Sau khi đăng tải
	INSERT INTO Bai_viet(Ma_bai_viet, Ten_bai_viet, Noi_dung, Ma_du_thao) VALUES
		('BV48968222', N'Sự thật về Trái đất', N'Trái đất có hình ELIP', 'DT48968222')
	SELECT * FROM Bai_viet WHERE Ma_bai_viet = 'BV48968222' -- Sau khi đăng tải
	SELECT * FROM Du_thao WHERE Ma_du_thao = 'DT48968222'	-- Sau khi đăng tải
ROLLBACK TRANSACTION
GO

--Yêu cầu 5: Thực hiện tạo Store Procedure:
-- Ta tạo một thủ tục để lập danh sách những bạn đọc bình luận từ N lần trở lên

CREATE PROCEDURE Nguoi_doc_N  @SoBL INT 
AS
BEGIN
    SELECT Nguoi_doc.Ma_nguoi_doc, Ten_hien_thi, So_dien_thoai, Dia_chi, SL_Binh_luan
	FROM (
		SELECT Ma_nguoi_doc, count(Ma_binh_luan) AS SL_Binh_luan 
			FROM Binh_luan GROUP BY Ma_nguoi_doc
				) AS Dem_SL_BL
		join Nguoi_doc 
		ON Dem_SL_BL.Ma_nguoi_doc = Nguoi_doc.Ma_nguoi_doc
	WHERE SL_Binh_luan >= @SoBL
	ORDER BY Ma_nguoi_doc
END
-- Thực thi thủ tục Store Procedure vừa tạo
EXEC Nguoi_doc_N @SoBL = 3 

--Yêu cầu 6: Thực hiện tạo Functions:
-- Ta tạo một function trả về 1 bảng gồm các bài viết được lọc theo một chuyên mục cụ thể

CREATE FUNCTION Filter_BV_CM(@MCM varchar(10))
RETURNS TABLE AS RETURN
(
	SELECT [dbo].[Bai_viet].Ma_bai_viet, [dbo].[Bai_viet].Ten_bai_viet, 
		[dbo].[Bai_viet].Noi_dung, convert(DATE, [dbo].[Bai_viet].TG_dang_bai) as Ngay_dang,
		[dbo].[Phong_vien].Ho_ten as Tac_gia, [dbo].[Chuyen_muc].Ten_chuyen_muc
	FROM [dbo].[Bai_viet]
	JOIN [dbo].[Phong_vien]
	ON [dbo].[Bai_viet].Ma_phong_vien = [dbo].[Phong_vien].Ma_phong_vien
	JOIN [dbo].[Chuyen_muc]
	ON [dbo].[Bai_viet].Ma_chuyen_muc = [dbo].[Chuyen_muc].Ma_chuyen_muc
	WHERE [dbo].[Bai_viet].Ma_chuyen_muc = @MCM
)

--Yêu cầu 7: Thực hiện tạo chỉ mục:
/* Trong SQL, các PRIMARY KEY của mỗi bảng đều là các Chỉ_mục (Index) tự động, ta tạo thêm một số chỉ mục khác như sau:*/
-- 7.1 Chỉ mục Ma_phong_vien, Ma_chuyen_muc cho bảng Bài viết để tăng tốc độ truy vấn bài báo bằng tác giả và chuyên mục
CREATE NONCLUSTERED INDEX idx_Bai_viet_MPV_and_MCM ON Bai_viet(Ma_phong_vien, Ma_chuyen_muc);
GO

-- 7.2 Chỉ mục Ma_nguoi_doc, Noi_dung_BL cho bảng Bình luận để tăng tốc độ truy vấn bằng mã người đọc hoặc nội dung BL
CREATE NONCLUSTERED INDEX idx_Binh_luan_MND ON Binh_luan(Ma_nguoi_doc);
CREATE NONCLUSTERED INDEX idx_Binh_luan_NDBL ON Binh_luan(Noi_dung_BL);
GO

--Yêu cầu 8: Thực hiện tạo transaction:
/*VD người đọc 'Đậu Quang Huy - Hải Phòng' vì lý do cá nhân muốn xóa tài khoản của mình kèm các nội dung liên quan,
trên CSDL ta biết mã người đọc là 'ND96008317'. Do bảng Bình_luận có ForeignKey đến bảng Người_đọc, ta tiến hành xóa đồng thời 
thông tin của người đọc trên cả 2 bảng Bình_Luận và Người_đọc bằng truy vấn sau: */

BEGIN TRANSACTION
	DECLARE @MND Varchar(10) = 'ND96008317'
	DELETE Binh_luan WHERE Ma_nguoi_doc = @MND
	DELETE Nguoi_doc WHERE Ma_nguoi_doc = @MND
COMMIT TRANSACTION  -- ROLLBACK TRANSACTION
GO

/* Điền lại thông tin sau khi xóa thành công
INSERT INTO Nguoi_doc VALUES
('ND96008317', 'huydqfx14879@gmail.com', N'Đậu Quang Huy', '', N'63 tổ 2 thị trấn An Dương, Huyện An Dương, Hải Phòng', '2017-03-20', 'CM005');
INSERT INTO Binh_luan(Ma_bai_viet, Noi_dung_BL, Ngay_BL, Ma_nguoi_doc) VALUES
('BV36694522', N'Một năm mất 10 tháng sửa chữa đứt cáp.', '2022-02-23 11:38:40.000', 'ND96008317'),
('BV63269022', N'Mỗi khi nghẹt mũi mình thường xông mũi bằng viên tinh dầu tràm mua ở tiệm thuốc tây, mình thấy đỡ hơn rất nhiều', '2022-02-23 06:06:18.000', 'ND96008317'),
('BV42509422', N'Nói thật không thích facebook nhưng vẫn còn hơn tiktok', '2022-02-19 12:59:13.000', 'ND96008317');*/

--Yêu cầu 9: Thực hiện các truy vấn đơn giản trên CSDL đã tạo
-- 9.1 Truy vấn dữ liệu trên một bảng (VD truy vấn tất cả các bản ghi trong bảng Dự thảo)
SELECT * FROM Du_thao;
GO

-- 9.2 Truy vấn có sử dụng Order by (VD truy vấn tên bài viết, mã phóng viên, ngày đăng của các bài viết được sắp xếp từ mới đến cũ)
SELECT Ten_bai_viet, Ma_chuyen_muc, Ma_phong_vien, convert(DATE, TG_dang_bai) as Ngay_dang
FROM Bai_viet
ORDER BY Ngay_dang DESC
GO
-- 9.3 Truy vấn sử dụng toán tử Like và các so sánh xâu ký tự.
-- Viết các thông tin về những người đọc có địa chỉ tại Hà Nội
SELECT * 
FROM Nguoi_doc
WHERE Dia_chi like N'%Hà Nội'
GO
-- 9.4 Truy vấn liên quan tới điều kiện về thời gian
-- VD truy vấn các bình luận được viết ngoài giờ hành chính, từ sau 17h30 chiều đến trước 8h sáng
SELECT *
FROM Binh_luan
WHERE	convert(time, Ngay_BL) between '00:00:00' and '07:59:59'
	or	convert(time, Ngay_BL) between '17:30:01' and '23:59:59.999'
GO
--Yêu cầu 10. Truy vấn dữ liệu từ nhiều bảng
-- 10.1 Truy vấn dữ liệu từ nhiều bảng sử dụng Inner join:
-- Truy vấn họ tên, email, tên bài viết của những phóng viên có điểm tin cậy lớn hơn hoặc bằng 90
SELECT PV.Ho_ten, Email_PV, BV.Ten_bai_viet
FROM Phong_vien AS PV
	join Bai_viet AS BV
	on PV.Ma_phong_vien = BV.Ma_phong_vien
WHERE Do_tin_cay >=90
GO
-- 10.2 Truy vấn sử dụng Self join:
-- Ta truy vấn tên các phóng viên cùng viết bài cho một chuyên mục bằng câu lệnh:
SELECT P1.Ma_chuyen_muc, C.Ten_chuyen_muc, P1.Ho_ten, P2.Ho_ten
FROM Phong_vien as P1
	join Phong_vien as P2
	on P1.Ma_chuyen_muc = P2.Ma_chuyen_muc and P1.Ma_phong_vien < P2.Ma_phong_vien
	join Chuyen_muc as C on P1.Ma_chuyen_muc = C.Ma_chuyen_muc  -- lấy tên chuyên mục theo Mã_CM
ORDER BY P1.Ma_chuyen_muc
GO
-- 10.3 Truy vấn sử dụng Outer join:
-- Truy vấn Mã phóng viên, họ tên, email của những phóng viên chưa có bài báo nào được đăng
SELECT PV.Ma_phong_vien, PV.Ho_ten, Email_PV
FROM Phong_vien AS PV
	Full Outer Join Bai_viet AS BV
	on PV.Ma_phong_vien = BV.Ma_phong_vien
WHERE Ma_bai_viet is NULL
GO
--Yêu cầu 11. Truy vấn dữ liệu sử dụng truy vấn con
-- VD Tìm chuyên mục được người đọc quan tâm nhất dựa trên số lượng bình luận:

WITH So_luong_binh_luan AS(
	SELECT BV.Ma_chuyen_muc, count(BL.Ma_binh_luan) as SL_BL
	FROM Bai_viet as BV
		join Binh_luan as BL
		on BV.Ma_bai_viet = BL.Ma_bai_viet
	GROUP BY BV.Ma_chuyen_muc)
SELECT TOP(1) S.Ma_chuyen_muc, C.Ten_chuyen_muc, S.SL_BL
FROM So_luong_binh_luan as S
	join Chuyen_muc as C
	on S.Ma_chuyen_muc = C.Ma_chuyen_muc
ORDER BY SL_BL DESC
GO
--Yêu cầu 12. Sử dụng group by và các hàm aggregate function
/* VD Lập danh sách Tên bài viết, số lượng bình luận của mỗi bài viết, Ngày đăng bài, sắp xếp theo số bình luận từ lớn đến nhỏ, 
nếu số bình luận như nhau thì sắp xếp bài viết từ mới đến cũ, mỗi bài viết phải tối thiểu có 3 bình luận*/
SELECT BV.Ten_bai_viet, count(BL.Ma_binh_luan) as SL_Binh_luan, convert(date, TG_dang_bai) as Ngày_đăng
FROM Bai_viet as BV
	join Binh_luan as BL
	on BV.Ma_bai_viet = BL.Ma_bai_viet
GROUP BY BV.Ten_bai_viet, convert(date, TG_dang_bai)
HAVING count(BL.Ma_binh_luan)>= 3
ORDER BY SL_Binh_luan DESC, ngày_đăng DESC

--Yêu cầu 13. Truy vấn dữ liệu sử dụng function đã viết ở mục trước.
SELECT * 
FROM dbo.Filter_BV_CM('CM004')
ORDER BY Ngay_dang DESC