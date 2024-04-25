# create database if not exists quanlydatphong;
use quanlydatphong;

create table if not exists category
(
    id     int auto_increment primary key,
    name   varchar(100) not null,
    unique (name),
    status tinyint default 1,
    check ( status in (0, 1))
);

create table if not exists room
(
    id          int auto_increment primary key,
    name        varchar(150) not null,
    status      tinyint default 1 check ( status in (0, 1)),
    price       float        not null,
    check ( price >= 100000),
    salePrice   float   default 0,
    check (salePrice <= price),
    createdDate date    default (now()),
    categoryId  int          not null,
    foreign key (categoryId) references category (id)

);

create index room_index_name on room (name);

create table if not exists customer
(
    id          int auto_increment primary key,
    name        varchar(50)  not null,
    unique (name),
    email       varchar(150) not null,
    phone       varchar(50)  not null,
    unique (phone),
    address     varchar(255),
    createdDate date default (now()),
    gender      tinyint      not null check ( gender in (0, 1, 2)),
    birthday    date         not null

);

create table if not exists booking
(
    id          int auto_increment primary key,
    customerId  int not null,
    foreign key (customerId) references customer (id),
    status      tinyint  default 1 check ( status in (0, 1, 2, 3) ),
    bookingDate datetime default (now())
);

create table if not exists bookingDetail
(
    bookingId int      not null,
    foreign key (bookingId) references booking (id),
    roomId    int      not null,
    foreign key (roomId) references room (id),
    price     float    not null,
    startDate datetime not null,
    endDate   datetime not null,
    check ( endDate > bookingDetail.startDate ),
    primary key (bookingId, roomId)

);
insert into category(name)
values ('president'),
       ('supervip'),
       ('business'),
       ('vip'),
       ('normal');

insert into room(name, price, salePrice, createdDate, categoryId)
values ('Tong thong', 150000000, 500000, '2024-04-01', 1),
       ('luxury', 5000000, 200000, '2024-04-01', 2),
       ('vip1', 1500000, 100000, '2024-04-01', 4),
       ('vip2', 1500000, 100000, '2024-04-02', 4),
       ('vip3', 1500000, 100000, '2024-04-03', 4),
       ('vip4', 1500000, 100000, '2024-04-04', 4),
       ('vip5', 1500000, 100000, '2024-04-05', 4),
       ('vip6', 1500000, 100000, '2024-04-06', 4),
       ('vip7', 1500000, 100000, '2024-04-07', 4),
       ('vip8', 1500000, 100000, '2024-04-08', 4),
       ('vip9', 1500000, 100000, '2024-04-09', 4),
       ('vip10', 1500000, 100000, '2024-04-11', 4),
       ('Tong thong1', 100000000, 500000, '2024-04-11', 1),
       ('danthuong', 500000, 500000, '2024-04-10', 5),
       ('business', 3000000, 500000, '2024-04-14', 3);

insert into room(name, status, price, salePrice, createdDate, categoryId)
values ('king supervip', 1, 500000000, 400000, now(), 1);

insert into room(name, status, price, salePrice, createdDate, categoryId)
values ('king supervip1', 1, 1000000000, 400000, now(), 1);

insert into room(name, status, price, salePrice, createdDate, categoryId)
values ('king supervip2', 1, 1000000000, 400000, now(), 1);



insert into customer(name, email, phone, address, gender, birthday)
values ('hung', 'h@gmail.com', 0912999999, 'hn', 0, '1996-01-22'),
       ('A', 'a@gmail.com', 0912888888, 'tn', 0, '1999-01-23'),
       ('B', 'b@gmail.com', 0912666666, 'nd', 1, '2003-01-24');

insert into booking (customerId)
values (1),
       (2),
       (3);

insert into bookingDetail(bookingId, roomId, price, startDate, endDate)
values (1, 1, 1500000, '2024-04-15 12:00:00', '2024-04-17 12:00:00'),
       (2, 2, 5000000, '2024-04-15 12:00:00', '2024-04-17 12:00:00'),
       (3, 3, 1500000, '2024-04-15 12:00:00', '2024-04-17 12:00:00');

# insert into bookingDetail(bookingId, roomId, price, startDate, endDate)
# values (2, 1, 1500000, '2024-04-15 12:00:00', '2024-04-17 12:00:00');

# 1.Lấy ra danh phòng có sắp xếp giảm dần theo Price gồm các cột sau: Id, Name, Price, SalePrice, Status, CategoryName, CreatedDate

select r.id, r.name, r.status, price, saleprice, createddate, c.name categoryName
from room r
         join category c on c.id = r.categoryId
order by price desc;


# 2.Lấy ra danh sách Category gồm: Id, Name, TotalRoom, Status (Trong đó cột Status nếu = 0, Ẩn, = 1 là Hiển thị )

# select c.Id, c.name, count(r.id) TotalRoom, c.status
# from category c
#          join room r on c.id = r.categoryId
# where c.status = 1
# group by c.id;

select c.Id,
       c.name,
       count(r.id)                                                                                                TotalRoom,
       case when c.status = 0 then 'Ẩn' when c.status = 1 then 'Hiển thị' else 'Trạng thái không xác định' end as Status
from category c
         join room r on c.id = r.categoryId
group by c.id;


# 3.Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender, BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )
select Id,
       Name,
       Email,
       Phone,
       Address,
       CreatedDate,
       case Gender
           when 1 then 'Nữ'
           when 0 then 'Nam'
           else 'khác'
           end as    gender,
       BirthDay,
       year(now()) - year(birthday) age
from customer;

# 4.Truy vấn xóa các sản phẩm chưa được bán
delete
from room
where id not in (select distinct bookingDetail.roomId from bookingDetail);

# 5.Cập nhật Cột SalePrice tăng thêm 10% cho tất cả các phòng có Price >= 250000

update room
set salePrice = price * 0.1
where price >= 250000;


# Yêu cầu 2 ( Sử dụng lệnh SQL tạo View )

# 1.	View v_getRoomInfo Lấy ra danh sách của 10 phòng có giá cao nhất
create view v_getroominfo as
select r.id,
       r.name,
       r.price,
       r.saleprice,
       r.status,
       c.name as categoryname,
       r.createddate
from room as r
         join
     category as c on r.categoryid = c.id
order by r.price desc
limit 10;


# 2.	View v_getBookingList hiển thị danh sách phiếu đặt hàng gồm:
# Id, BookingDate, Status, CusName, Email, Phone,TotalAmount
# ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt, = 2 Đã thanh toán, = 3 Đã hủy )
create view v_getbookinglist as
select b.id,
       b.bookingdate,
       b.status,
       c.name        as cusname,
       c.email,
       c.phone,
       sum(bd.price) as totalamount
from booking as b
         join
     customer as c on b.customerid = c.id
         join
     bookingdetail as bd on b.id = bd.bookingid
group by b.id,
         b.bookingdate,
         b.status,
         c.name,
         c.email,
         c.phone;


# 1.	Thủ tục addRoomInfo thực hiện thêm mới Room, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Room ( Trừ cột tự động tăng )
delimiter //
create procedure addroominfo(
    in room_name varchar(150),
    in room_status tinyint,
    in room_price float,
    in room_saleprice float,
    in room_createddate date,
    in room_categoryid int
)
begin
    insert into room(name, status, price, saleprice, createddate, categoryid)
    values (room_name, room_status, room_price, room_saleprice, room_createddate, room_categoryid);
end;
delimiter //

# call addroominfo('king supervip',1,500000000,400000, now(),1);


# 2.	Thủ tục getBookingByCustomerId hiển thị danh sách phieus đặt phòng của khách hàng theo Id khách hàng gồm: Id, BookingDate, Status, TotalAmount (Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy), Khi gọi thủ tục truyền vào id cảu khách hàng

delimiter //
create procedure getbookingbycustomerid(
    in customer_id int
)
begin
    select b.id,
           b.bookingdate,
           b.status,
           SUM(bd.price) as totalamount
    from booking as b
             join
         bookingdetail as bd on b.id = bd.bookingid
    where b.customerid = customer_id
    group by b.id,
             b.bookingdate,
             b.status;
end;
delimiter //

# call getbookingbycustomerid(1);

# 3.	Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm: Id, Name, Price, SalePrice, Khi gọi thủ tuc truyền vào limit và page

delimiter //
create procedure getroompaginate(
    in limit_val int,
    in page_val int
)
begin
    declare offset_val int default 0;

    set offset_val = (page_val - 1) * limit_val;

    select r.id, r.name, r.price, r.saleprice
    from room as r
    order by r.id
    limit limit_val offset offset_val;
end;

delimiter //

# call getRoomPaginate(10, 1);  Lấy 10 phòng ở trang 1

# Yêu cầu 4 ( Sử dụng lệnh SQL tạo Trigger )

# 1.	Tạo trigger tr_Check_Price_Value sao cho khi thêm hoặc sửa phòng Room nếu nếu giá trị của cột Price > 5000000 thì tự động chuyển về 5000000 và in ra thông báo ‘Giá phòng lớn nhất 5 triệu’

create trigger tr_check_price_value
    before insert
    on room
    for each row
begin
    if new.price > 5000000 then
        set new.price = 5000000;
#         select 'Giá phòng lớn nhất 5 triệu' as message;
#         signal sqlstate '45000' set message_text = 'giá phòng lớn nhất 5 triệu';
    end if;
end;


# 2.	Tạo trigger tr_check_room_notallow khi thực hiện đặt phòng, nếu ngày đến (startdate) và ngày đi (enddate) của đơn hiện tại mà phòng đã có người đặt rồi thì báo lỗi “phòng này đã có người đặt trong thời gian này, vui lòng chọn thời gian khác”


create trigger tr_check_room_notallow
    before insert
    on bookingdetail
    for each row
begin
    declare room_count int;
    select count(*)
    into room_count
    from bookingdetail
    where roomid = new.roomid
      and new.startdate < enddate
      and new.enddate > startdate;

    if room_count > 0 then
        signal sqlstate '45000' set message_text = 'phòng đã có người đặt trong khoảng thời gian này';
    end if;
end;
