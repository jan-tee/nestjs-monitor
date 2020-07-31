import { Controller, Inject, Logger, HttpStatus, Get } from '@nestjs/common';
import { MonitoringService } from './monitoring.service';

@Controller('monitoring')
export class MonitoringController {
  private readonly logger = new Logger('MonitoringController');

  constructor(@Inject(MonitoringService) private readonly monitoringService: MonitoringService) {
    this.logger.setContext('HealthController');
  }

  @Get('ping')
  public getPing() {
    return {
      statusCode: HttpStatus.OK,
      status: 'success',
    };
  }

  @Get('metrics')
  public getMetrics() {
    return this.monitoringService.getMetrics();
  }
}
