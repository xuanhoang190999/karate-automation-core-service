package app.services;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.math.RoundingMode;
import app.dataAccess.ScheduleMaintenanceDA;
import app.shareds.models.ScheduleMaintenancePlanService;
import app.shareds.models.ScheduleMaintenanceServiceInfo;

public class ScheduleMaintenanceService {

    private final ScheduleMaintenanceDA scheduleMaintenanceDA;

    public ScheduleMaintenanceService(ScheduleMaintenanceDA scheduleMaintenanceDA) {
        this.scheduleMaintenanceDA = scheduleMaintenanceDA;
    }

    public List<ScheduleMaintenanceServiceInfo> getScheduledMaintenanceNextServiceForVehicle(
            int year, String make, String model, String engineType, String engineVINCode, String transmission,
            String trimLevel, int currentMileage,
            int currentKilometers)
            throws Exception {
        List<ScheduleMaintenanceServiceInfo> results = new ArrayList<>();

        List<ScheduleMaintenancePlanService> planServiceDetails = scheduleMaintenanceDA
                .getScheduleMaintenancePlanServicesByVehicle(
                        "en-us",
                        year,
                        make,
                        model,
                        engineType,
                        engineVINCode,
                        transmission,
                        trimLevel);

        if (planServiceDetails == null || planServiceDetails.isEmpty())
            return results;

        System.out.println("[DEBUG] planServiceDetails: " + planServiceDetails.size());

        List<ScheduleMaintenancePlanService> nextServices = getNextService(currentMileage, currentKilometers,
                planServiceDetails);

        System.out.println("[DEBUG] nextServices: " + nextServices.size());

        for (ScheduleMaintenancePlanService scheduleMaintenancePlanService : nextServices) {
            ScheduleMaintenanceServiceInfo item = new ScheduleMaintenanceServiceInfo();
            item.fixNameId = scheduleMaintenancePlanService.fixNameId;
            item.mileage = scheduleMaintenancePlanService.nextServiceMileageInterval;
            item.kilometers = scheduleMaintenancePlanService.nextServiceKilometersInterval;
            item.serviceName = scheduleMaintenancePlanService.serviceName;

            results.add(item);
        }

        return results;
    }

    private List<ScheduleMaintenancePlanService> getNextService(
            Integer currentMileage,
            Integer currentKilometers,
            List<ScheduleMaintenancePlanService> planServiceDetails) {

        List<ScheduleMaintenancePlanService> nextServices = new ArrayList<>();

        if (currentMileage != null) {
            int minInterval = planServiceDetails.stream()
                    .filter(x -> x.mileageRepeat > 0)
                    .map(x -> x.mileageRepeat)
                    .min(Integer::compareTo)
                    .orElse(0);

            BigDecimal range = BigDecimal.valueOf(minInterval).multiply(BigDecimal.valueOf(0.15));

            for (ScheduleMaintenancePlanService detail : planServiceDetails) {
                if (detail.mileageRepeat <= 0)
                    continue;

                int firstMileage = detail.mileage;
                int mileage = currentMileage;

                if (firstMileage > 0) {
                    if (mileage < firstMileage) {
                        BigDecimal D = BigDecimal.valueOf(firstMileage - mileage);
                        if (D.compareTo(range) <= 0) {
                            detail.nextServiceMileageInterval = firstMileage;
                            if (detail.nextServiceMileageInterval > 0) {
                                nextServices.add(detail);
                            }
                        }
                        continue;
                    } else {
                        mileage -= firstMileage;
                    }
                }

                BigDecimal bdMileage = BigDecimal.valueOf(mileage);
                BigDecimal bdRepeat = BigDecimal.valueOf(detail.mileageRepeat);

                BigDecimal mul = bdMileage.divide(bdRepeat, 10, RoundingMode.HALF_UP);

                BigDecimal integerPart = new BigDecimal(mul.toBigInteger());
                BigDecimal R = mul.subtract(integerPart);

                if (R.compareTo(BigDecimal.valueOf(0.5)) > 0) {
                    R = BigDecimal.ONE.subtract(R);
                }

                BigDecimal X = R.multiply(bdRepeat);
                if (X.compareTo(range) <= 0) {
                    int nextInterval = getNextServiceMileageInterval(mileage, mul, firstMileage, detail.mileageRepeat);
                    detail.nextServiceMileageInterval = nextInterval;
                    if (detail.nextServiceMileageInterval > 0) {
                        nextServices.add(detail);
                    }
                }
            }

        } else if (currentKilometers != null) {
            int minInterval = planServiceDetails.stream()
                    .filter(x -> x.kilometersRepeat > 0)
                    .map(x -> x.kilometersRepeat)
                    .min(Integer::compareTo)
                    .orElse(0);

            BigDecimal range = BigDecimal.valueOf(minInterval).multiply(BigDecimal.valueOf(0.15));

            for (ScheduleMaintenancePlanService detail : planServiceDetails) {
                if (detail.kilometersRepeat <= 0)
                    continue;

                int firstKm = detail.kilometers;
                int km = currentKilometers;

                if (firstKm > 0) {
                    if (km < firstKm) {
                        BigDecimal D = BigDecimal.valueOf(firstKm - km);
                        if (D.compareTo(range) <= 0) {
                            detail.nextServiceKilometersInterval = firstKm;
                            if (detail.nextServiceKilometersInterval > 0) {
                                nextServices.add(detail);
                            }
                        }
                        continue;
                    } else {
                        km -= firstKm;
                    }
                }

                BigDecimal bdKm = BigDecimal.valueOf(km);
                BigDecimal bdRepeat = BigDecimal.valueOf(detail.kilometersRepeat);

                BigDecimal mul = bdKm.divide(bdRepeat, 10, RoundingMode.HALF_UP);
                BigDecimal integerPart = new BigDecimal(mul.toBigInteger());
                BigDecimal R = mul.subtract(integerPart);

                if (R.compareTo(BigDecimal.valueOf(0.5)) > 0) {
                    R = BigDecimal.ONE.subtract(R);
                }

                BigDecimal X = R.multiply(bdRepeat);
                if (X.compareTo(range) <= 0) {
                    int nextInterval = getNextServiceKilometersInterval(km, mul, firstKm, detail.kilometersRepeat);
                    detail.nextServiceKilometersInterval = nextInterval;
                    if (detail.nextServiceKilometersInterval > 0) {
                        nextServices.add(detail);
                    }
                }
            }
        }

        return nextServices;
    }

    // private double roundX(double value) {
    // return Math.round(value);
    // }

    private int getNextServiceMileageInterval(int currentMileage, BigDecimal mul, int firstMileage, int mileageRepeat) {
        int nextServiceMileageInterval = 0;

        int x = mul.intValue();
        BigDecimal y = mul.subtract(BigDecimal.valueOf(x));

        if (y.compareTo(BigDecimal.valueOf(0.15)) <= 0) {
            nextServiceMileageInterval = x * mileageRepeat + firstMileage;
        } else {
            nextServiceMileageInterval = (x + 1) * mileageRepeat + firstMileage;
        }

        return nextServiceMileageInterval;
    }

    private int getNextServiceKilometersInterval(int currentKilometers, BigDecimal mul, int firstKilometers,
            int kilometersRepeat) {
        int nextServiceKilometersInterval = 0;

        int x = mul.intValue();
        BigDecimal y = mul.subtract(BigDecimal.valueOf(x));

        if (y.compareTo(BigDecimal.valueOf(0.15)) <= 0) {
            nextServiceKilometersInterval = x * kilometersRepeat + firstKilometers;
        } else {
            nextServiceKilometersInterval = (x + 1) * kilometersRepeat + firstKilometers;
        }

        return nextServiceKilometersInterval;
    }
}