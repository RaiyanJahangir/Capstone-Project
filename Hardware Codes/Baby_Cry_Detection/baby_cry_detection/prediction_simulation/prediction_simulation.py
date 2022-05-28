# -*- coding: utf-8 -*-

import argparse
import logging
import os
import pickle
import timeit
import warnings
import pyttsx3

from baby_cry_detection.rpi_methods import Reader
from baby_cry_detection.rpi_methods.feature_engineer import FeatureEngineer
from baby_cry_detection.rpi_methods.majority_voter import MajorityVoter

from baby_cry_detection.rpi_methods.baby_cry_predictor import BabyCryPredictor

import firebase_admin
from firebase_admin import credentials
from firebase_admin import db


cred = credentials.Certificate("D:\Android_Studio_Projects\Capstone-Project\Hardware Codes\Baby_Cry_Detection\\baby_cry_detection\prediction_simulation\\firebase-python-sdk.json")
#firebase_admin.initialize_app(cred)
default_app = firebase_admin.initialize_app(cred, {
	'databaseURL':'https://integrated-design-projec-1e9b8-default-rtdb.firebaseio.com'
	})

ref = db.reference("/Sensor Data")
# cry_state=ref.get()
# print(cry_state)
#ref.update({"Cry":"YES"})


def main():
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--load_path_data',
                        default=os.path.dirname(os.path.abspath(__file__)))
    parser.add_argument('--load_path_model',
                        default='{}/../../output/model/'.format(os.path.dirname(os.path.abspath(__file__))))
    parser.add_argument('--save_path',
                        default='{}/../../output/prediction/'.format(os.path.dirname(os.path.abspath(__file__))))
    parser.add_argument('--file_name', default='baby.wav')
    parser.add_argument('--log_path',
                        default='{}/../../'.format(os.path.dirname(os.path.abspath(__file__))))

    # Arguments
    args = parser.parse_args()
    load_path_data = os.path.normpath(args.load_path_data)
    load_path_model = os.path.normpath(args.load_path_model)
    
    file_name = args.file_name
    save_path = os.path.normpath(args.save_path)
    log_path = os.path.normpath(args.log_path)

     # Set up logging
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s',
                        datefmt='%Y-%m-%d %I:%M:%S %p',
                        filename=os.path.join(log_path, 'logs_prediction_test_test_model.log'),
                        filemode='w',
                        level=logging.INFO)

    # READ RAW SIGNAL

    logging.info('Reading {0}'.format(file_name))
    start = timeit.default_timer()

    # Read signal (first 5 sec)
    file_reader = Reader(os.path.join(load_path_data, file_name))

    play_list = file_reader.read_audio_file()

    stop = timeit.default_timer()
    logging.info('Time taken for reading file: {0}'.format(stop - start))

    # FEATURE ENGINEERING

    logging.info('Starting feature engineering')
    start = timeit.default_timer()

    # Feature extraction
    engineer = FeatureEngineer()

    play_list_processed = list()

    for signal in play_list:
        tmp = engineer.feature_engineer(signal)
        play_list_processed.append(tmp)

    stop = timeit.default_timer()
    logging.info('Time taken for feature engineering: {0}'.format(stop - start))

    # MAKE PREDICTION

    logging.info('Predicting...')
    start = timeit.default_timer()

    # https://stackoverflow.com/questions/41146759/check-sklearn-version-before-loading-model-using-joblib
    with warnings.catch_warnings():
      warnings.simplefilter("ignore", category=UserWarning)

      with open((os.path.join(load_path_model, 'model.pkl')), 'rb') as fp:
          model = pickle.load(fp)

    predictor = BabyCryPredictor(model)

    predictions = list()

    for signal in play_list_processed:
        tmp = predictor.classify(signal)
        predictions.append(tmp)

    # MAJORITY VOTE

    majority_voter = MajorityVoter(predictions)
    majority_vote = majority_voter.vote()
    

    stop = timeit.default_timer()
    logging.info('Time taken for prediction: {0}. Is it a baby cry?? {1}'.format(stop - start, majority_vote))

    # SAVE

    logging.info('Saving prediction...')

    # Save prediction result
    
    with open(os.path.join(save_path, 'prediction.txt'), 'wb') as text_file:
        text_file.write("{}".format(majority_vote).encode())
    if majority_vote ==1:
       engine = pyttsx3.init()
       engine.setProperty('rate', 150)  # Setting up voice rate
       engine.setProperty('volume', 80)
 

       engine.say('Baby is crying')
       ref.update({"Cry":"YES"})
 

       engine.runAndWait()
    else:
        engine = pyttsx3.init()
       

        engine.say('This not a baby cry')
        ref.update({"Cry":"NO"})
 

        engine.runAndWait()
    logging.info('Saved! {}'.format(os.path.join(save_path, 'prediction.txt')))


if __name__ == '__main__':
    main()
