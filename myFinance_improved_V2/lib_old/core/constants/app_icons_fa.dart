import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfinance_improved/core/themes/index.dart';

/// 매장 관리 앱을 위한 Font Awesome 아이콘 시스템 (300+ 아이콘)
/// 
/// 사용법:
/// ```dart
/// // 기본 사용
/// FaIcon(AppIcons.dashboard)
/// 
/// // 색상과 크기 지정
/// FaIcon(
///   AppIcons.sales,
///   color: TossColors.success,
///   size: 30,
/// )
/// ```
class AppIcons {
  AppIcons._();

  // ==================== 1. 대시보드 & 홈 (15개) ====================
  static const IconData dashboard = FontAwesomeIcons.chartLine;
  static const IconData dashboardAlt = FontAwesomeIcons.gaugeHigh;
  static const IconData home = FontAwesomeIcons.house;
  static const IconData homeAlt = FontAwesomeIcons.houseChimney;
  static const IconData homeUser = FontAwesomeIcons.houseUser;
  static const IconData homeLaptop = FontAwesomeIcons.houseLaptop;
  static const IconData homeSignal = FontAwesomeIcons.houseSignal;
  static const IconData grid = FontAwesomeIcons.tableColumns;
  static const IconData gridAlt = FontAwesomeIcons.tableCells;
  static const IconData overview = FontAwesomeIcons.eye;
  static const IconData summary = FontAwesomeIcons.listCheck;
  static const IconData workspace = FontAwesomeIcons.desktop;
  static const IconData control = FontAwesomeIcons.gamepad;
  static const IconData panel = FontAwesomeIcons.tablet;
  static const IconData monitor = FontAwesomeIcons.tv;

  // ==================== 2. 매장 & 비즈니스 (20개) ====================
  static const IconData store = FontAwesomeIcons.shop;
  static const IconData storeAlt = FontAwesomeIcons.store;
  static const IconData storeSlash = FontAwesomeIcons.storeSlash;
  static const IconData building = FontAwesomeIcons.building;
  static const IconData buildingColumns = FontAwesomeIcons.buildingColumns;
  static const IconData buildingFlag = FontAwesomeIcons.buildingFlag;
  static const IconData buildingLock = FontAwesomeIcons.buildingLock;
  static const IconData buildingShield = FontAwesomeIcons.buildingShield;
  static const IconData buildingUser = FontAwesomeIcons.buildingUser;
  static const IconData industry = FontAwesomeIcons.industry;
  static const IconData warehouse = FontAwesomeIcons.warehouse;
  static const IconData factory = FontAwesomeIcons.industry;
  static const IconData office = FontAwesomeIcons.briefcase;
  static const IconData company = FontAwesomeIcons.sitemap;
  static const IconData branch = FontAwesomeIcons.codeBranch;
  static const IconData franchise = FontAwesomeIcons.networkWired;
  static const IconData business = FontAwesomeIcons.businessTime;
  static const IconData enterprise = FontAwesomeIcons.city;
  static const IconData marketplace = FontAwesomeIcons.shopify;
  static const IconData mall = FontAwesomeIcons.bagShopping;

  // ==================== 3. 재무 & 돈 (30개) ====================
  static const IconData money = FontAwesomeIcons.moneyBill;
  static const IconData moneyWave = FontAwesomeIcons.moneyBillWave;
  static const IconData moneyCheck = FontAwesomeIcons.moneyCheck;
  static const IconData moneyCheckDollar = FontAwesomeIcons.moneyCheckDollar;
  static const IconData moneyBills = FontAwesomeIcons.moneyBill1Wave;
  static const IconData cash = FontAwesomeIcons.sackDollar;
  static const IconData cashRegister = FontAwesomeIcons.cashRegister;
  static const IconData wallet = FontAwesomeIcons.wallet;
  static const IconData piggyBank = FontAwesomeIcons.piggyBank;
  static const IconData vault = FontAwesomeIcons.vault;
  static const IconData coins = FontAwesomeIcons.coins;
  static const IconData bitcoin = FontAwesomeIcons.bitcoin;
  static const IconData ethereum = FontAwesomeIcons.ethereum;
  static const IconData dollarSign = FontAwesomeIcons.dollarSign;
  static const IconData euroSign = FontAwesomeIcons.euroSign;
  static const IconData yenSign = FontAwesomeIcons.yenSign;
  static const IconData wonSign = FontAwesomeIcons.wonSign;
  static const IconData rubleSign = FontAwesomeIcons.rubleSign;
  static const IconData rupeeSign = FontAwesomeIcons.rupeeSign;
  static const IconData creditCard = FontAwesomeIcons.creditCard;
  static const IconData ccVisa = FontAwesomeIcons.ccVisa;
  static const IconData ccMastercard = FontAwesomeIcons.ccMastercard;
  static const IconData ccAmex = FontAwesomeIcons.ccAmex;
  static const IconData ccPaypal = FontAwesomeIcons.ccPaypal;
  static const IconData ccStripe = FontAwesomeIcons.ccStripe;
  static const IconData ccApplePay = FontAwesomeIcons.ccApplePay;
  static const IconData googlePay = FontAwesomeIcons.googlePay;
  static const IconData amazonPay = FontAwesomeIcons.amazonPay;
  static const IconData paypal = FontAwesomeIcons.paypal;
  static const IconData stripe = FontAwesomeIcons.stripe;

  // ==================== 4. 차트 & 분석 (25개) ====================
  static const IconData chartLine = FontAwesomeIcons.chartLine;
  static const IconData chartBar = FontAwesomeIcons.chartColumn;
  static const IconData chartPie = FontAwesomeIcons.chartPie;
  static const IconData chartArea = FontAwesomeIcons.chartArea;
  static const IconData chartGantt = FontAwesomeIcons.chartGantt;
  static const IconData chartSimple = FontAwesomeIcons.chartSimple;
  static const IconData chartMixed = FontAwesomeIcons.squarePollVertical;
  static const IconData analytics = FontAwesomeIcons.magnifyingGlassChart;
  static const IconData diagram = FontAwesomeIcons.diagramProject;
  static const IconData diagramNext = FontAwesomeIcons.diagramNext;
  static const IconData diagramPredecessor = FontAwesomeIcons.diagramPredecessor;
  static const IconData diagramSuccessor = FontAwesomeIcons.diagramSuccessor;
  static const IconData trend = FontAwesomeIcons.arrowTrendUp;
  static const IconData trendDown = FontAwesomeIcons.arrowTrendDown;
  static const IconData growth = FontAwesomeIcons.seedling;
  static const IconData performance = FontAwesomeIcons.gaugeHigh;
  static const IconData gauge = FontAwesomeIcons.gauge;
  static const IconData gaugeSimple = FontAwesomeIcons.gaugeSimple;
  static const IconData gaugeHigh = FontAwesomeIcons.gaugeHigh;
  static const IconData signal = FontAwesomeIcons.signal;
  static const IconData signalPerfect = FontAwesomeIcons.signal;
  static const IconData poll = FontAwesomeIcons.squarePollHorizontal;
  static const IconData ranking = FontAwesomeIcons.rankingStar;
  static const IconData medal = FontAwesomeIcons.medal;
  static const IconData trophy = FontAwesomeIcons.trophy;

  // ==================== 5. 재고 & 제품 (25개) ====================
  static const IconData inventory = FontAwesomeIcons.boxesStacked;
  static const IconData inventoryAlt = FontAwesomeIcons.boxesStacked;
  static const IconData box = FontAwesomeIcons.box;
  static const IconData boxOpen = FontAwesomeIcons.boxOpen;
  static const IconData boxArchive = FontAwesomeIcons.boxArchive;
  static const IconData boxesPacking = FontAwesomeIcons.boxesPacking;
  static const IconData package = FontAwesomeIcons.cube;
  static const IconData packages = FontAwesomeIcons.cubes;
  static const IconData packageStacked = FontAwesomeIcons.cubesStacked;
  static const IconData product = FontAwesomeIcons.tag;
  static const IconData products = FontAwesomeIcons.tags;
  static const IconData barcode = FontAwesomeIcons.barcode;
  static const IconData qrcode = FontAwesomeIcons.qrcode;
  static const IconData scanner = FontAwesomeIcons.expand;
  static const IconData pallet = FontAwesomeIcons.pallet;
  static const IconData palletBoxes = FontAwesomeIcons.boxesStacked;
  static const IconData container = FontAwesomeIcons.squareFull;
  static const IconData containerStorage = FontAwesomeIcons.database;
  static const IconData shelf = FontAwesomeIcons.bars;
  static const IconData stock = FontAwesomeIcons.layerGroup;
  static const IconData stockOut = FontAwesomeIcons.circleExclamation;
  static const IconData stockIn = FontAwesomeIcons.circleCheck;
  static const IconData supply = FontAwesomeIcons.truckRampBox;
  static const IconData supplyChain = FontAwesomeIcons.link;
  static const IconData logistics = FontAwesomeIcons.route;

  // ==================== 6. 쇼핑 & 판매 (20개) ====================
  static const IconData cart = FontAwesomeIcons.cartShopping;
  static const IconData cartPlus = FontAwesomeIcons.cartPlus;
  static const IconData cartArrow = FontAwesomeIcons.cartArrowDown;
  static const IconData cartFlatbed = FontAwesomeIcons.cartFlatbed;
  static const IconData basket = FontAwesomeIcons.basketShopping;
  static const IconData bag = FontAwesomeIcons.bagShopping;
  static const IconData sale = FontAwesomeIcons.percent;
  static const IconData discount = FontAwesomeIcons.ticketSimple;
  static const IconData coupon = FontAwesomeIcons.ticket;
  static const IconData gift = FontAwesomeIcons.gift;
  static const IconData gifts = FontAwesomeIcons.gifts;
  static const IconData giftCard = FontAwesomeIcons.creditCard;
  static const IconData receipt = FontAwesomeIcons.receipt;
  static const IconData invoice = FontAwesomeIcons.fileInvoice;
  static const IconData invoiceDollar = FontAwesomeIcons.fileInvoiceDollar;
  static const IconData bill = FontAwesomeIcons.fileLines;
  static const IconData purchase = FontAwesomeIcons.handHoldingDollar;
  static const IconData checkout = FontAwesomeIcons.cashRegister;
  static const IconData pos = FontAwesomeIcons.desktop;
  static const IconData terminal = FontAwesomeIcons.terminal;

  // ==================== 7. 사용자 & 직원 (30개) ====================
  static const IconData user = FontAwesomeIcons.user;
  static const IconData userAlt = FontAwesomeIcons.userLarge;
  static const IconData userCircle = FontAwesomeIcons.circleUser;
  static const IconData userTie = FontAwesomeIcons.userTie;
  static const IconData userGraduate = FontAwesomeIcons.userGraduate;
  static const IconData userDoctor = FontAwesomeIcons.userDoctor;
  static const IconData userNurse = FontAwesomeIcons.userNurse;
  static const IconData userSecret = FontAwesomeIcons.userSecret;
  static const IconData userShield = FontAwesomeIcons.userShield;
  static const IconData userLock = FontAwesomeIcons.userLock;
  static const IconData userCheck = FontAwesomeIcons.userCheck;
  static const IconData userClock = FontAwesomeIcons.userClock;
  static const IconData userEdit = FontAwesomeIcons.userPen;
  static const IconData userGear = FontAwesomeIcons.userGear;
  static const IconData userPlus = FontAwesomeIcons.userPlus;
  static const IconData userMinus = FontAwesomeIcons.userMinus;
  static const IconData userXmark = FontAwesomeIcons.userXmark;
  static const IconData userSlash = FontAwesomeIcons.userSlash;
  static const IconData userTag = FontAwesomeIcons.userTag;
  static const IconData users = FontAwesomeIcons.users;
  static const IconData usersGear = FontAwesomeIcons.usersGear;
  static const IconData usersLine = FontAwesomeIcons.usersLine;
  static const IconData usersRays = FontAwesomeIcons.usersRays;
  static const IconData usersRectangle = FontAwesomeIcons.usersRectangle;
  static const IconData usersSlash = FontAwesomeIcons.usersSlash;
  static const IconData userGroup = FontAwesomeIcons.userGroup;
  static const IconData peopleArrows = FontAwesomeIcons.peopleArrows;
  static const IconData peopleCarry = FontAwesomeIcons.peopleCarryBox;
  static const IconData peopleGroup = FontAwesomeIcons.peopleGroup;
  static const IconData peopleLine = FontAwesomeIcons.peopleLine;

  // ==================== 8. 시간 & 일정 (25개) ====================
  static const IconData clock = FontAwesomeIcons.clock;
  static const IconData clockRotate = FontAwesomeIcons.clockRotateLeft;
  static const IconData stopwatch = FontAwesomeIcons.stopwatch;
  static const IconData stopwatch20 = FontAwesomeIcons.stopwatch20;
  static const IconData hourglass = FontAwesomeIcons.hourglass;
  static const IconData hourglassStart = FontAwesomeIcons.hourglassStart;
  static const IconData hourglassHalf = FontAwesomeIcons.hourglassHalf;
  static const IconData hourglassEnd = FontAwesomeIcons.hourglassEnd;
  static const IconData calendar = FontAwesomeIcons.calendar;
  static const IconData calendarDays = FontAwesomeIcons.calendarDays;
  static const IconData calendarWeek = FontAwesomeIcons.calendarWeek;
  static const IconData calendarDay = FontAwesomeIcons.calendarDay;
  static const IconData calendarCheck = FontAwesomeIcons.calendarCheck;
  static const IconData calendarPlus = FontAwesomeIcons.calendarPlus;
  static const IconData calendarMinus = FontAwesomeIcons.calendarMinus;
  static const IconData calendarXmark = FontAwesomeIcons.calendarXmark;
  static const IconData businessTime = FontAwesomeIcons.businessTime;
  static const IconData timeline = FontAwesomeIcons.timeline;
  static const IconData history = FontAwesomeIcons.clockRotateLeft;
  static const IconData schedule = FontAwesomeIcons.calendarDays;
  static const IconData alarm = FontAwesomeIcons.bell;
  static const IconData timer = FontAwesomeIcons.stopwatch;
  static const IconData deadline = FontAwesomeIcons.hourglassEnd;
  static const IconData shift = FontAwesomeIcons.userClock;
  static const IconData timesheet = FontAwesomeIcons.fileLines;

  // ==================== 9. 문서 & 파일 (30개) ====================
  static const IconData file = FontAwesomeIcons.file;
  static const IconData fileAlt = FontAwesomeIcons.fileLines;
  static const IconData fileBlank = FontAwesomeIcons.file;
  static const IconData fileContract = FontAwesomeIcons.fileContract;
  static const IconData fileInvoice = FontAwesomeIcons.fileInvoice;
  static const IconData fileInvoiceDollar = FontAwesomeIcons.fileInvoiceDollar;
  static const IconData filePdf = FontAwesomeIcons.filePdf;
  static const IconData fileExcel = FontAwesomeIcons.fileExcel;
  static const IconData fileWord = FontAwesomeIcons.fileWord;
  static const IconData filePowerpoint = FontAwesomeIcons.filePowerpoint;
  static const IconData fileImage = FontAwesomeIcons.fileImage;
  static const IconData fileVideo = FontAwesomeIcons.fileVideo;
  static const IconData fileAudio = FontAwesomeIcons.fileAudio;
  static const IconData fileCode = FontAwesomeIcons.fileCode;
  static const IconData fileArchive = FontAwesomeIcons.fileZipper;
  static const IconData fileCsv = FontAwesomeIcons.fileCsv;
  static const IconData fileDownload = FontAwesomeIcons.fileArrowDown;
  static const IconData fileUpload = FontAwesomeIcons.fileArrowUp;
  static const IconData fileExport = FontAwesomeIcons.fileExport;
  static const IconData fileImport = FontAwesomeIcons.fileImport;
  static const IconData fileSignature = FontAwesomeIcons.fileSignature;
  static const IconData fileShield = FontAwesomeIcons.fileShield;
  static const IconData fileMedical = FontAwesomeIcons.fileMedical;
  static const IconData fileCircleCheck = FontAwesomeIcons.fileCircleCheck;
  static const IconData fileCircleXmark = FontAwesomeIcons.fileCircleXmark;
  static const IconData fileCirclePlus = FontAwesomeIcons.fileCirclePlus;
  static const IconData fileCircleMinus = FontAwesomeIcons.fileCircleMinus;
  static const IconData folder = FontAwesomeIcons.folder;
  static const IconData folderOpen = FontAwesomeIcons.folderOpen;
  static const IconData folderTree = FontAwesomeIcons.folderTree;

  // ==================== 10. 통신 & 메시지 (20개) ====================
  static const IconData message = FontAwesomeIcons.message;
  static const IconData messages = FontAwesomeIcons.comments;
  static const IconData comment = FontAwesomeIcons.comment;
  static const IconData comments = FontAwesomeIcons.comments;
  static const IconData commentDots = FontAwesomeIcons.commentDots;
  static const IconData commentSms = FontAwesomeIcons.commentSms;
  static const IconData envelope = FontAwesomeIcons.envelope;
  static const IconData envelopeOpen = FontAwesomeIcons.envelopeOpen;
  static const IconData envelopeCircle = FontAwesomeIcons.envelopeCircleCheck;
  static const IconData inbox = FontAwesomeIcons.inbox;
  static const IconData paperPlane = FontAwesomeIcons.paperPlane;
  static const IconData phone = FontAwesomeIcons.phone;
  static const IconData phoneVolume = FontAwesomeIcons.phoneVolume;
  static const IconData phoneSlash = FontAwesomeIcons.phoneSlash;
  static const IconData phoneFlip = FontAwesomeIcons.phoneFlip;
  static const IconData video = FontAwesomeIcons.video;
  static const IconData videoSlash = FontAwesomeIcons.videoSlash;
  static const IconData voicemail = FontAwesomeIcons.voicemail;
  static const IconData headset = FontAwesomeIcons.headset;
  static const IconData microphone = FontAwesomeIcons.microphone;

  // ==================== 11. 보안 & 권한 (20개) ====================
  static const IconData lock = FontAwesomeIcons.lock;
  static const IconData lockOpen = FontAwesomeIcons.lockOpen;
  static const IconData unlock = FontAwesomeIcons.unlock;
  static const IconData key = FontAwesomeIcons.key;
  static const IconData shield = FontAwesomeIcons.shield;
  static const IconData shieldHalved = FontAwesomeIcons.shieldHalved;
  static const IconData shieldHeart = FontAwesomeIcons.shieldHeart;
  static const IconData shieldVirus = FontAwesomeIcons.shieldVirus;
  static const IconData fingerprint = FontAwesomeIcons.fingerprint;
  static const IconData idCard = FontAwesomeIcons.idCard;
  static const IconData idCardClip = FontAwesomeIcons.idCardClip;
  static const IconData idBadge = FontAwesomeIcons.idBadge;
  static const IconData passport = FontAwesomeIcons.passport;
  static const IconData certificate = FontAwesomeIcons.certificate;
  static const IconData stamp = FontAwesomeIcons.stamp;
  static const IconData signature = FontAwesomeIcons.signature;
  static const IconData userSecret2 = FontAwesomeIcons.userSecret;
  static const IconData mask = FontAwesomeIcons.mask;
  static const IconData eyeSlash = FontAwesomeIcons.eyeSlash;
  static const IconData ban = FontAwesomeIcons.ban;

  // ==================== 12. 교통 & 배송 (20개) ====================
  static const IconData truck = FontAwesomeIcons.truck;
  static const IconData truckFast = FontAwesomeIcons.truckFast;
  static const IconData truckMoving = FontAwesomeIcons.truckMoving;
  static const IconData truckLoading = FontAwesomeIcons.truckRampBox;
  static const IconData truckDroplet = FontAwesomeIcons.truckDroplet;
  static const IconData van = FontAwesomeIcons.vanShuttle;
  static const IconData car = FontAwesomeIcons.car;
  static const IconData carSide = FontAwesomeIcons.carSide;
  static const IconData carRear = FontAwesomeIcons.carRear;
  static const IconData motorcycle = FontAwesomeIcons.motorcycle;
  static const IconData bicycle = FontAwesomeIcons.bicycle;
  static const IconData plane = FontAwesomeIcons.plane;
  static const IconData ship = FontAwesomeIcons.ship;
  static const IconData train = FontAwesomeIcons.train;
  static const IconData subway = FontAwesomeIcons.trainSubway;
  static const IconData bus = FontAwesomeIcons.bus;
  static const IconData taxi = FontAwesomeIcons.taxi;
  static const IconData helicopter = FontAwesomeIcons.helicopter;
  static const IconData rocket = FontAwesomeIcons.rocket;
  static const IconData drone = FontAwesomeIcons.satelliteDish;

  // ==================== 13. 액션 & 조작 (30개) ====================
  static const IconData add = FontAwesomeIcons.plus;
  static const IconData minus = FontAwesomeIcons.minus;
  static const IconData times = FontAwesomeIcons.xmark;
  static const IconData check = FontAwesomeIcons.check;
  static const IconData checkDouble = FontAwesomeIcons.checkDouble;
  static const IconData checkCircle = FontAwesomeIcons.circleCheck;
  static const IconData checkSquare = FontAwesomeIcons.squareCheck;
  static const IconData plusCircle = FontAwesomeIcons.circlePlus;
  static const IconData plusSquare = FontAwesomeIcons.squarePlus;
  static const IconData minusCircle = FontAwesomeIcons.circleMinus;
  static const IconData minusSquare = FontAwesomeIcons.squareMinus;
  static const IconData timesCircle = FontAwesomeIcons.circleXmark;
  static const IconData timesSquare = FontAwesomeIcons.squareXmark;
  static const IconData edit = FontAwesomeIcons.penToSquare;
  static const IconData editAlt = FontAwesomeIcons.pen;
  static const IconData pencil = FontAwesomeIcons.pencil;
  static const IconData eraser = FontAwesomeIcons.eraser;
  static const IconData trash = FontAwesomeIcons.trash;
  static const IconData trashCan = FontAwesomeIcons.trashCan;
  static const IconData trashRestore = FontAwesomeIcons.trashArrowUp;
  static const IconData save = FontAwesomeIcons.floppyDisk;
  static const IconData copy = FontAwesomeIcons.copy;
  static const IconData paste = FontAwesomeIcons.paste;
  static const IconData cut = FontAwesomeIcons.scissors;
  static const IconData undo = FontAwesomeIcons.arrowRotateLeft;
  static const IconData redo = FontAwesomeIcons.arrowRotateRight;
  static const IconData refresh = FontAwesomeIcons.arrowsRotate;
  static const IconData sync = FontAwesomeIcons.rotate;
  static const IconData syncAlt = FontAwesomeIcons.rotateRight;
  static const IconData repeat = FontAwesomeIcons.repeat;

  // ==================== 14. 네비게이션 (25개) ====================
  static const IconData arrowUp = FontAwesomeIcons.arrowUp;
  static const IconData arrowDown = FontAwesomeIcons.arrowDown;
  static const IconData arrowLeft = FontAwesomeIcons.arrowLeft;
  static const IconData arrowRight = FontAwesomeIcons.arrowRight;
  static const IconData arrowUpLong = FontAwesomeIcons.arrowUpLong;
  static const IconData arrowDownLong = FontAwesomeIcons.arrowDownLong;
  static const IconData arrowLeftLong = FontAwesomeIcons.arrowLeftLong;
  static const IconData arrowRightLong = FontAwesomeIcons.arrowRightLong;
  static const IconData arrowTurnUp = FontAwesomeIcons.arrowTurnUp;
  static const IconData arrowTurnDown = FontAwesomeIcons.arrowTurnDown;
  static const IconData arrowsUpDown = FontAwesomeIcons.arrowsUpDown;
  static const IconData arrowsLeftRight = FontAwesomeIcons.arrowsLeftRight;
  static const IconData chevronUp = FontAwesomeIcons.chevronUp;
  static const IconData chevronDown = FontAwesomeIcons.chevronDown;
  static const IconData chevronLeft = FontAwesomeIcons.chevronLeft;
  static const IconData chevronRight = FontAwesomeIcons.chevronRight;
  static const IconData angleUp = FontAwesomeIcons.angleUp;
  static const IconData angleDown = FontAwesomeIcons.angleDown;
  static const IconData angleLeft = FontAwesomeIcons.angleLeft;
  static const IconData angleRight = FontAwesomeIcons.angleRight;
  static const IconData caretUp = FontAwesomeIcons.caretUp;
  static const IconData caretDown = FontAwesomeIcons.caretDown;
  static const IconData caretLeft = FontAwesomeIcons.caretLeft;
  static const IconData caretRight = FontAwesomeIcons.caretRight;
  static const IconData circleArrowUp = FontAwesomeIcons.circleArrowUp;

  // ==================== 15. UI 컴포넌트 (20개) ====================
  static const IconData bars = FontAwesomeIcons.bars;
  static const IconData barsStaggered = FontAwesomeIcons.barsStaggered;
  static const IconData barsProgress = FontAwesomeIcons.barsProgress;
  static const IconData navicon = FontAwesomeIcons.bars;
  static const IconData ellipsis = FontAwesomeIcons.ellipsis;
  static const IconData ellipsisVertical = FontAwesomeIcons.ellipsisVertical;
  static const IconData grip = FontAwesomeIcons.grip;
  static const IconData gripVertical = FontAwesomeIcons.gripVertical;
  static const IconData gripLines = FontAwesomeIcons.gripLines;
  static const IconData gripLinesVertical = FontAwesomeIcons.gripLinesVertical;
  static const IconData list = FontAwesomeIcons.list;
  static const IconData listUl = FontAwesomeIcons.listUl;
  static const IconData listOl = FontAwesomeIcons.listOl;
  static const IconData listCheck = FontAwesomeIcons.listCheck;
  static const IconData table = FontAwesomeIcons.table;
  static const IconData tableCells = FontAwesomeIcons.tableCells;
  static const IconData tableCellsLarge = FontAwesomeIcons.tableCellsLarge;
  static const IconData tableColumns = FontAwesomeIcons.tableColumns;
  static const IconData tableList = FontAwesomeIcons.tableList;
  static const IconData sliders = FontAwesomeIcons.sliders;

  // ==================== 16. 미디어 (15개) ====================
  static const IconData play = FontAwesomeIcons.play;
  static const IconData pause = FontAwesomeIcons.pause;
  static const IconData stop = FontAwesomeIcons.stop;
  static const IconData forward = FontAwesomeIcons.forward;
  static const IconData backward = FontAwesomeIcons.backward;
  static const IconData fastForward = FontAwesomeIcons.forwardFast;
  static const IconData fastBackward = FontAwesomeIcons.backwardFast;
  static const IconData stepForward = FontAwesomeIcons.forwardStep;
  static const IconData stepBackward = FontAwesomeIcons.backwardStep;
  static const IconData eject = FontAwesomeIcons.eject;
  static const IconData volumeHigh = FontAwesomeIcons.volumeHigh;
  static const IconData volumeLow = FontAwesomeIcons.volumeLow;
  static const IconData volumeOff = FontAwesomeIcons.volumeOff;
  static const IconData volumeMute = FontAwesomeIcons.volumeXmark;
  static const IconData music = FontAwesomeIcons.music;

  // ==================== 17. 도구 & 설정 (20개) ====================
  static const IconData gear = FontAwesomeIcons.gear;
  static const IconData gears = FontAwesomeIcons.gears;
  static const IconData wrench = FontAwesomeIcons.wrench;
  static const IconData screwdriver = FontAwesomeIcons.screwdriver;
  static const IconData screwdriverWrench = FontAwesomeIcons.screwdriverWrench;
  static const IconData hammer = FontAwesomeIcons.hammer;
  static const IconData toolbox = FontAwesomeIcons.toolbox;
  static const IconData compass = FontAwesomeIcons.compass;
  static const IconData compassDrafting = FontAwesomeIcons.compassDrafting;
  static const IconData ruler = FontAwesomeIcons.ruler;
  static const IconData rulerCombined = FontAwesomeIcons.rulerCombined;
  static const IconData rulerHorizontal = FontAwesomeIcons.rulerHorizontal;
  static const IconData rulerVertical = FontAwesomeIcons.rulerVertical;
  static const IconData paintbrush = FontAwesomeIcons.paintbrush;
  static const IconData paintRoller = FontAwesomeIcons.paintRoller;
  static const IconData palette = FontAwesomeIcons.palette;
  static const IconData magnet = FontAwesomeIcons.magnet;
  static const IconData filter = FontAwesomeIcons.filter;
  static const IconData filterCircle = FontAwesomeIcons.filterCircleXmark;
  static const IconData sort = FontAwesomeIcons.arrowDownWideShort;

  // ==================== 18. 상태 & 알림 (20개) ====================
  static const IconData info = FontAwesomeIcons.circleInfo;
  static const IconData infoCircle = FontAwesomeIcons.circleInfo;
  static const IconData question = FontAwesomeIcons.circleQuestion;
  static const IconData questionCircle = FontAwesomeIcons.circleQuestion;
  static const IconData exclamation = FontAwesomeIcons.circleExclamation;
  static const IconData exclamationCircle = FontAwesomeIcons.circleExclamation;
  static const IconData exclamationTriangle = FontAwesomeIcons.triangleExclamation;
  static const IconData warning = FontAwesomeIcons.triangleExclamation;
  static const IconData bell = FontAwesomeIcons.bell;
  static const IconData bellSlash = FontAwesomeIcons.bellSlash;
  static const IconData bellConcierge = FontAwesomeIcons.bellConcierge;
  static const IconData notification = FontAwesomeIcons.bell;
  static const IconData flag = FontAwesomeIcons.flag;
  static const IconData flagCheckered = FontAwesomeIcons.flagCheckered;
  static const IconData bookmark = FontAwesomeIcons.bookmark;
  static const IconData bookmarkSolid = FontAwesomeIcons.solidBookmark;
  static const IconData star = FontAwesomeIcons.star;
  static const IconData starHalf = FontAwesomeIcons.starHalf;
  static const IconData starHalfStroke = FontAwesomeIcons.starHalfStroke;
  static const IconData heart = FontAwesomeIcons.heart;

  // ==================== 19. 소셜 미디어 (15개) ====================
  static const IconData facebook = FontAwesomeIcons.facebook;
  static const IconData twitter = FontAwesomeIcons.twitter;
  static const IconData instagram = FontAwesomeIcons.instagram;
  static const IconData linkedin = FontAwesomeIcons.linkedin;
  static const IconData youtube = FontAwesomeIcons.youtube;
  static const IconData tiktok = FontAwesomeIcons.tiktok;
  static const IconData pinterest = FontAwesomeIcons.pinterest;
  static const IconData snapchat = FontAwesomeIcons.snapchat;
  static const IconData reddit = FontAwesomeIcons.reddit;
  static const IconData whatsapp = FontAwesomeIcons.whatsapp;
  static const IconData telegram = FontAwesomeIcons.telegram;
  static const IconData discord = FontAwesomeIcons.discord;
  static const IconData slack = FontAwesomeIcons.slack;
  static const IconData github = FontAwesomeIcons.github;
  static const IconData google = FontAwesomeIcons.google;

  // ==================== 20. 기타 유용한 아이콘 (25개) ====================
  static const IconData search = FontAwesomeIcons.magnifyingGlass;
  static const IconData searchPlus = FontAwesomeIcons.magnifyingGlassPlus;
  static const IconData searchMinus = FontAwesomeIcons.magnifyingGlassMinus;
  static const IconData searchDollar = FontAwesomeIcons.magnifyingGlassDollar;
  static const IconData searchLocation = FontAwesomeIcons.magnifyingGlassLocation;
  static const IconData print = FontAwesomeIcons.print;
  static const IconData download = FontAwesomeIcons.download;
  static const IconData upload = FontAwesomeIcons.upload;
  static const IconData share = FontAwesomeIcons.share;
  static const IconData shareNodes = FontAwesomeIcons.shareNodes;
  static const IconData shareFromSquare = FontAwesomeIcons.shareFromSquare;
  static const IconData link = FontAwesomeIcons.link;
  static const IconData linkSlash = FontAwesomeIcons.linkSlash;
  static const IconData paperclip = FontAwesomeIcons.paperclip;
  static const IconData thumbsUp = FontAwesomeIcons.thumbsUp;
  static const IconData thumbsDown = FontAwesomeIcons.thumbsDown;
  static const IconData handshake = FontAwesomeIcons.handshake;
  static const IconData handshakeAngle = FontAwesomeIcons.handshakeAngle;
  static const IconData handshakeSlash = FontAwesomeIcons.handshakeSlash;
  static const IconData hands = FontAwesomeIcons.hands;
  static const IconData handsClapping = FontAwesomeIcons.handsClapping;
  static const IconData handHolding = FontAwesomeIcons.handHolding;
  static const IconData handHoldingDollar = FontAwesomeIcons.handHoldingDollar;
  static const IconData handHoldingHeart = FontAwesomeIcons.handHoldingHeart;
  static const IconData globe = FontAwesomeIcons.globe;

  // ==================== 헬퍼 메서드 ====================
  
  /// FaIcon 위젯 생성 헬퍼
  static Widget getIcon(
    IconData icon, {
    double? size,
    Color? color,
  }) {
    return FaIcon(
      icon,
      size: size ?? 24,
      color: color,
    );
  }
  
  /// 카테고리별 아이콘 그룹
  static final Map<String, Map<String, IconData>> iconGroups = {
    '대시보드': {
      'dashboard': dashboard,
      'home': home,
      'overview': overview,
      'monitor': monitor,
    },
    '재무': {
      'money': money,
      'cash': cash,
      'wallet': wallet,
      'creditCard': creditCard,
    },
    '재고': {
      'inventory': inventory,
      'box': box,
      'warehouse': warehouse,
      'barcode': barcode,
    },
    '직원': {
      'user': user,
      'users': users,
      'userTie': userTie,
      'userClock': userClock,
    },
    '판매': {
      'cart': cart,
      'sale': sale,
      'receipt': receipt,
      'cashRegister': cashRegister,
    },
  };
  
  /// 자주 사용하는 아이콘 매핑
  static final Map<String, IconData> commonIcons = {
    // 네비게이션
    'home': home,
    'dashboard': dashboard,
    'settings': gear,
    'menu': bars,
    
    // CRUD
    'add': add,
    'edit': edit,
    'delete': trash,
    'save': save,
    
    // 검색 & 필터
    'search': search,
    'filter': filter,
    'sort': sort,
    
    // 액션
    'refresh': refresh,
    'download': download,
    'upload': upload,
    'share': share,
    'print': print,
  };
}
