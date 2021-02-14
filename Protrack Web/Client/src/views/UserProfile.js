import React, { useState } from 'react';
import {
  Button,
  Card,
  CardHeader,
  CardBody,
  CardFooter,
  CardText,
  FormGroup,
  Form,
  Input,
  Row,
  Col,
} from 'reactstrap';
import store from '../Store';
import { connect } from 'react-redux';

function UserProfile(props) {
  console.log(store.getState().email);
  const [email, setEmail] = useState(store.getState().email);
  return (
    <>
      <div className='content'>
        <Row>
          <Col md='8'>
            <Card>
              <CardHeader>
                <h5 className='title'>Edit Profile</h5>
              </CardHeader>
              <CardBody>
                <Form
                  onSubmit={(e) => {
                    e.preventDefault();
                    console.log('object');
                    props.dispatch({
                      type: 'SET_EMAIL',
                      payload: email,
                    });
                  }}
                >
                  <Row>
                    <Col className='pr-md-1' md='5'>
                      <FormGroup>
                        <label>Company</label>
                        <Input
                          defaultValue='Company Name'
                          placeholder='Company'
                          type='text'
                        />
                      </FormGroup>
                    </Col>
                    <Col className='px-md-1' md='3'>
                      <FormGroup>
                        <label>Username</label>
                        <Input placeholder='Username' type='text' />
                      </FormGroup>
                    </Col>
                    <Col className='pl-md-1' md='4'>
                      <FormGroup>
                        <label htmlFor='exampleInputEmail1'>
                          Email address
                        </label>
                        <Input
                          id='email'
                          value={email}
                          type='text'
                          onChange={(e) => setEmail(e.target.value)}
                        />
                      </FormGroup>
                    </Col>
                  </Row>
                  <Row>
                    <Col className='pr-md-1' md='6'>
                      <FormGroup>
                        <label>First Name</label>
                        <Input placeholder='Company' type='text' />
                      </FormGroup>
                    </Col>
                    <Col className='pl-md-1' md='6'>
                      <FormGroup>
                        <label>Last Name</label>
                        <Input placeholder='Last Name' type='text' />
                      </FormGroup>
                    </Col>
                  </Row>
                  <Row>
                    <Col md='12'>
                      <FormGroup>
                        <label>Address</label>
                        <Input
                          defaultValue='Bld Mihail Kogalniceanu, nr. 8 Bl 1, Sc 1, Ap 09'
                          placeholder='Home Address'
                          type='text'
                        />
                      </FormGroup>
                    </Col>
                  </Row>
                  <Row>
                    <Col className='pr-md-1' md='4'>
                      <FormGroup>
                        <label>City</label>
                        <Input
                          defaultValue='Mike'
                          placeholder='City'
                          type='text'
                        />
                      </FormGroup>
                    </Col>
                    <Col className='px-md-1' md='4'>
                      <FormGroup>
                        <label>Country</label>
                        <Input
                          defaultValue='Andrew'
                          placeholder='Country'
                          type='text'
                        />
                      </FormGroup>
                    </Col>
                    <Col className='pl-md-1' md='4'>
                      <FormGroup>
                        <label>Postal Code</label>
                        <Input placeholder='ZIP Code' type='number' />
                      </FormGroup>
                    </Col>
                  </Row>
                  <Row>
                    <Col md='8'>
                      <FormGroup>
                        <label>About Me</label>
                        <Input
                          cols='80'
                          defaultValue="Lamborghini Mercy, Your chick she so thirsty, I'm in
                            that two seat Lambo."
                          placeholder='Here can be your description'
                          rows='4'
                          type='textarea'
                        />
                      </FormGroup>
                    </Col>
                  </Row>
                  <Button className='btn-fill' color='primary' type='submit'>
                    Save
                  </Button>
                </Form>
              </CardBody>
              <CardFooter></CardFooter>
            </Card>
          </Col>
          <Col md='4'>
            <Card className='card-user'>
              <CardBody>
                <CardText />
                <div className='author'>
                  <div className='block block-one' />
                  <div className='block block-two' />
                  <div className='block block-three' />
                  <div className='block block-four' />
                  <a href='#pablo' onClick={(e) => e.preventDefault()}>
                    <img
                      alt='...'
                      className='avatar'
                      src={require('assets/img/emilyz.jpg').default}
                    />
                    <h5 className='title'>Mike Andrew</h5>
                  </a>
                  <p className='description'>Ceo/Co-Founder</p>
                </div>
                <div className='card-description'>
                  Do not be scared of the truth because we need to restart the
                  human foundation in truth And I love you like Kanye loves
                  Kanye I love Rick Owens’ bed design but the back is...
                </div>
              </CardBody>
              <CardFooter>
                <div className='button-container'>
                  <Button className='btn-icon btn-round' color='facebook'>
                    <i className='fab fa-facebook' />
                  </Button>
                  <Button className='btn-icon btn-round' color='twitter'>
                    <i className='fab fa-twitter' />
                  </Button>
                  <Button className='btn-icon btn-round' color='google'>
                    <i className='fab fa-google-plus' />
                  </Button>
                </div>
              </CardFooter>
            </Card>
          </Col>
        </Row>
      </div>
    </>
  );
}

const mapStateToProps = (state, ownProps) => {
  return {
    email: state.email,
  };
};
export default connect(mapStateToProps)(UserProfile);
