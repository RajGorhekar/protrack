import React from 'react';
import { Line } from 'react-chartjs-2';
import { Card, CardHeader, CardBody, CardTitle, Row, Col } from 'reactstrap';
import { chartExample1, chartExample2 } from 'variables/charts.js';

function Dashboard(props) {
  return (
    <div className='content'>
      <Row>
        <Col xs='12'>
          <Card className='card-chart'>
            <CardHeader>
              <Row>
                <Col className='text-left' sm='6'>
                  <CardTitle tag='h3'>
                    <i className='tim-icons icon-bell-55 text-info' />
                    Productive App Time Usage
                  </CardTitle>
                </Col>
              </Row>
            </CardHeader>
            <CardBody>
              <div className='chart-area'>
                <Line
                  data={chartExample1.data1}
                  options={chartExample1.options}
                />
              </div>
            </CardBody>
          </Card>
        </Col>
      </Row>
      <Row>
        <Col lg='12'>
          <Card className='card-chart'>
            <CardHeader>
              <CardTitle tag='h3'>
                <i className='tim-icons icon-bell-55 text-info' /> Non
                Productive App Time Usage
              </CardTitle>
            </CardHeader>
            <CardBody>
              <div className='chart-area'>
                <Line
                  data={chartExample2.data}
                  options={chartExample2.options}
                />
              </div>
            </CardBody>
          </Card>
        </Col>
      </Row>
    </div>
  );
}

export default Dashboard;
