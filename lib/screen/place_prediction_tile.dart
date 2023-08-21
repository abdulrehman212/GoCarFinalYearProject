/*
import 'package:flutter/material.dart';
import 'package:fyp_gocar/assistants/request_assistant.dart';
import 'package:fyp_gocar/models/directions.dart';
import 'package:fyp_gocar/key/map_key.dart';
import 'package:fyp_gocar/screen/predicted_places.dart';
import 'package:fyp_gocar/widgets/progress_bar.dart';
import 'package:get/get.dart';

class PlacePredictionTileDesign extends StatelessWidget
{
  final PredictedPlaces? predictedPlaces;
  

  PlacePredictionTileDesign({this.predictedPlaces});

  getPlaceDirectionDetails(String? placeId, context) async
  {
    showDialog(
        context: context,
        builder: (BuildContext context) => Expanded(
          child: ProgressBar(
            message: "Setting Up Location, Please wait...",
          ),
        ),
    );

    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occurred, Failed. No Response.")
    {
      return;
    }

    if(responseApi["status"] == "OK")
    {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];


      // Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
      //to check the results

      print("location name : "+directions.locationName!);
      print("location lat : " +directions.locationLatitude!.toString());
      print("location long : "+directions.locationLongitude!.toString());

      Navigator.pop(context, "obtainedDetails");
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return ElevatedButton(
      onPressed: ()
      {
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);

      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white24,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.grey,
            ),
            const SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0,),
                  
                    Text(
                      predictedPlaces!.main_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white54,
                      ),
                    
                  ),
                  const SizedBox(height: 2.0,),
                  /*Text(
                    predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                    ),
                  ),*/
                  const SizedBox(height: 8.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Directions pickUpLocation = Directions();
Directions dropOffLocation = Directions();
*/