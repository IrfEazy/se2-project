open util/ordering[DateTime]

sig Appointment {
	startDate : DateTime,
	endDate : DateTime,
	chargingPoint : ChargingPoint
} {this in Calendar.appointments}

sig Calendar {appointments : disj set Appointment} {this in EVD.calendar}

sig ChargingPoint {
	eV : disj lone EV,
	plugs : some Plug
} {
	EV.plug in plugs and
	this in ChargingStation.chargingPoints
}

sig ChargingStation {chargingPoints : disj some ChargingPoint} {this in CPO.chargingStations}

sig CPO {chargingStations : disj some ChargingStation}

sig DateTime {} {this in Appointment.startDate + Appointment.endDate}

sig Email {} {this in EVD.email}

sig EV {plug : Plug} {this in UnregisteredEVD.eVs}

sig Password {} {this in EVD.password}

abstract sig Plug {}
one sig CCS extends Plug {}
one sig ChaDeMo extends Plug {}
one sig Type1 extends Plug {}
one sig Type2 extends Plug {}

abstract sig UnregisteredEVD {eVs : disj some EV}
sig EVD extends UnregisteredEVD {
	calendar : disj Calendar,
	email : disj Email,
	password : disj Password
}

/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
///* An EVD cannot charge his EVs simultaneously, we assume each account is associated to only one driver
fact evdsCanChargeOnlyOneEvPerTime {
	all evd : EVD, disj ev1, ev2 : EV |
		ev1 + ev2 in evd.eVs and
		ev1 in ChargingPoint.eV implies
			ev2 not in ChargingPoint.eV
}
///* An appointment must start before ending
fact appointmentsAreCorrect {
	all a : Appointment |
		lt [a.startDate, a.endDate]
}
///* A booking process must not be overlapped to another booking process in the same calendar and in the same charging point
fact noOverlappedAppointmentsInChargingPointSchedules {
	no disj a1, a2 : Appointment |
		a1.chargingPoint in a2.chargingPoint and
		gte [a1.startDate, a2.startDate] and
		lte [a1.startDate, a2.endDate]
	no c : Calendar, disj a1, a2 : c.appointments |
		gte [a1.startDate, a2.startDate] and
		lte [a1.startDate, a2.endDate]
}

/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
///* No overlapped appointments in charging point schedules
assert noOverlappedAppointmentsInChargingPointSchedules {
	no disj a1, a2 : Appointment |
		a1.chargingPoint in a2.chargingPoint and
			lte [a1.startDate, a2.startDate] and
			lte [a1.endDate, a2.startDate]
}
///* EVs are connected to compatible charging points
assert evsAreConnectedToCompatibleChargingPoints {
	no cp : ChargingPoint |
		cp.eV.plug not in cp.plugs
}

/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/

/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/

pred show {}

run show for 10

check noOverlappedAppointmentsInChargingPointSchedules

check evsAreConnectedToCompatibleChargingPoints
