import { MonitoringController } from './monitoring.controller';
import { MonitoringService } from './monitoring.service';

describe('MonitoringController', () => {
  let monitorCtrl: MonitoringController;
  let monitorSvc: MonitoringService;

  beforeEach(() => {
    monitorSvc = new MonitoringService();
    monitorCtrl = new MonitoringController(monitorSvc);
  });

  describe('register a logger', () => {
    it('should register the logger', () => {
      monitorSvc.registerLogger(() => 'static txt');
    });
  });
});
