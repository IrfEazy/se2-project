open util/ordering[Time]

sig Time{}
/*
sig Appointment {
	calendar: one Calendar,
	endDate: one Date,
	startDate: one Date,
	electricVehicleDriver: one ElectricVehicleDriver,
}
*//*
sig Calendar {
	appointments: some Appointment,
	chargingPoint: one ChargingPoint,
	electricVehicleDriver: one ElectricVehicleDriver,
}
*/
sig ChargingPoint {
	chargingStation: one ChargingStation,
	electricVehicle: one ElectricVehicle,
	plugs: some Plug,
}

sig ChargingStation {
	chargingPoints: some ChargingPoint,
	electricVehicles: some ElectricVehicle,
}
/*
sig Date {
	day: one Int,
	month: one Int,
	time: one Time,
	year: one Int,
}
*/
sig ElectricVehicle {
	plug: one Plug,
	chargingPoint: lone ChargingPoint,
}

sig ElectricVehicleDriver {
	email: one Email,
	password: one Password,
	electricVehicle: one ElectricVehicle,
}

sig Email {}

sig Password {}

abstract sig Plug {}
one sig CCS extends Plug {}
one sig ChaDeMo extends Plug {}
one sig Type1 extends Plug {}
one sig Type2 extends Plug {}

/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/

fact chargingPointsAreAssociatedWithChargingStations {
	all cs: ChargingStation, cp: ChargingPoint |
		cs in cp.chargingStation iff cp in cs.chargingPoints
}

fact evIsAssociatedWithChargingPointIfConnected {
	all cp: ChargingPoint, ev: ElectricVehicle |
		ev in cp.electricVehicle iff cp in ev.chargingPoint
}

fact evsAreAssociatedWithChargingStationIfWaitingOrCharging {
	all cs: ChargingStation, ev: ElectricVehicle |
		ev.chargingPoint in cs.chargingPoints implies ev in cs.electricVehicles
}

fact evIsConnectedToTheRightPlug {
	all cp: ChargingPoint, ev: ElectricVehicle |
		ev in cp.electricVehicle and ev.plug in cp.plugs iff cp in ev.chargingPoint
}

fact evsAreNotSharedAmongChargingStations {
	all ev: ElectricVehicle, cs1, cs2: ChargingStation |
		cs1 != cs2 implies (ev in cs1.electricVehicles iff ev not in cs2.electricVehicles)
}

fact evsAreNotSharedAmongEvds {
	all ev: ElectricVehicle, evd1, evd2: ElectricVehicleDriver |
		evd1 != evd2 implies (ev in evd1.electricVehicle iff ev not in evd2.electricVehicle)
}

fact emailsAreNotSharedAmongEvds {
	all e: Email, evd1, evd2: ElectricVehicleDriver |
		evd1 != evd2 implies (e in evd1.email iff e not in evd2.email)
}
/*
fact evdsAreNotSharedAmongCalendars {
	all evd: ElectricVehicleDriver, c1, c2: Calendar |
		c1 != c2 implies (evd in c1.electricVehicleDriver iff evd not in c2.electricVehicleDriver)
}
*/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/

pred show {
}

run show for 3
