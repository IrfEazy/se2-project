// signatures

//sig String {}
sig DSO {
	supplyFee: one Int,
	cpmsList: some CPMS
}

sig CPMS {
	chargingStations: some ChargingStation,
	cpo: one CPO
}

sig CPO {
	identifier: one Int,
	commercialName: one String,
	cpms: one CPMS
}

sig eMSP {
	users: some User,
	cpmsList: some CPMS
}

sig ChargingStation {
	identifier: one Int,
	columnsCount: one Int,
	position: one Position,
	chargingPoints: some ChargingPoint
}

sig ChargingPoint {
	identifier: one Int,
	chargingStation: one ChargingStation,
	status: one Status,
	plugList: set Plug
}

////////////////////////////////////////////////////////////////////////////////

sig Date {
	day: one Int,
	month: one Int,
	year: one Int,
	hour: one Int,
	minutes: one Int,
	seconds: one Int
}

sig Calendar {
	owner: one User,
	chargingPoint: one ChargingPoint,
	appointmentLists: set Appointment
}

sig Appointment {
	startingDate: one Date,
	endingDate: one Date,
	user: one User,
	calendar: one Calendar
}

sig User {
	identifier: one Int,
	email: one String,
	password: one String,
	birthday: one Date,
	vehicle: set ElectricVehicle
}

sig ElectricVehicle {
	identifier: one Int,
	producer: one String,
	model: one String,
	year: one Int,
	capacity: one Int,
	owner: one User,
	plugType: one Plug
} {
	capacity > 0
}

sig Position {
	latitude: one Int,
	longitute: one Int,
	accuracy: one Int,
}

abstract sig Status {}
one sig Broken extends Status {}
one sig Booked extends Status {}
one sig Free extends Status {}
one sig Occupied extends Status {}

abstract sig Notification {}
sig eMail extends Notification {}
sig mobileNotification extends Notification {} 

abstract sig Fee {}

abstract sig Plug {
	electricVehicle: lone ElectricVehicle,
	chargingPoint: set ChargingPoint
}
one sig Type1 extends Plug {}
one sig Type2 extends Plug {}
one sig CCS extends Plug {}
one sig ChaDeMo extends Plug {}

////////////////////////////////////////////////////////////////////////////////

// predicates and facts

/*fact allChargingPointHasOneStatus {
	all c: ChargingPoint | one s: Status | s in c.status
}*/

fact allChargingPointHasSomePlug {
	all c: ChargingPoint | some p: Plug | p in c.plugList
}

/*fact allAppointmentHasOneUser {
	all a: Appointment | one u: User | u in a.user
}*/

/*fact allAppointmentHasOneCalendar {
	all a: Appointment | one c: Calendar | c in a.calendar
}*/

fact allUserUniqueId {
	no disjoint u1, u2: User | u1.identifier = u2.identifier 
}

fact allElectricVehicleUniqueId {
	no disjoint ev1, ev2: ElectricVehicle | ev1.identifier = ev2.identifier 
}

fact allChargingStationUniqueId {
	no disjoint cs1, cs2: ChargingStation | cs1.identifier = cs2.identifier
}

fact allChargingPointUniqueId {
	no disjoint cp1, cp2: ChargingPoint | cp1.identifier = cp2.identifier
}

fact allCPOUniqueId {
	no disjoint cpo1, cpo2: CPO | cpo1.identifier = cpo2.identifier
}

fact chargintPointsAreColumnsCount {
	all cs: ChargingStation | #cs.chargingPoints = cs.columnsCount
}

fact chargingPointsAreNotShared {
	all cs: ChargingStation, cp: ChargingPoint |
		cp.chargingStation = cs iff cp in cs.chargingPoints
}

fact cpoHasAssociatedOnlyOneCpms {
	all cpoOperator: CPO, cpmsSystem: CPMS |
		cpoOperator.cpms = cpmsSystem iff cpmsSystem.cpo = cpoOperator
}

//fact cpmsHasAssociatedOnlyOneDso {
//	all cpms: CPMS, dso: DSO | 
//}

//fact dateIsConsistent {
//	all d: Date |
//		
//}

/* --- DYNAMIC MODELING --- */

pred addAppointment [cal, cal': Calendar, a: Appointment] {
	cal'.appointmentLists = cal.appointmentLists + a
}

pred addChargingPoint [chs, chs': ChargingStation, chp: ChargingPoint] {
	chs'.chargingPoints = chs.chargingPoints + chp
	chs'.columnsCount = chs.columnsCount + 1
}

pred addElectricVehicle [us, us': User, ev: ElectricVehicle] {
	us'.vehicle = us.vehicle + ev
}

pred addChargingStation [cpms, cpms': CPMS, chs: ChargingStation] {
	cpms'.chargingStations = cpms.chargingStations + chs
}

pred addNotification [] {

}

/* ----------------------- */

pred pred1 {
	#Date = 0
	#Calendar = 0
	#Appointment = 0
	#User = 0
}

run pred1 for 3
