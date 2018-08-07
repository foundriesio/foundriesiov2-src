+++
author = "Alan Bennett"
banner = "/uploads/2018/05/09/assistant.png"
categories = ["mp containers", "linux microplatform"]
date = "2018-05-09T19:48:23+00:00"
tags = ["Google", "Assistant", "Alsa"]
title = "Google Assistant on the LmP"

+++
In this blog, I describe how to run the Google Assistant SDK on a Raspberry Pi with an external speaker and microphone.  After you get things configured and gather key pieces of information you'll have a simple, portable and easy to reproduce Google Assistant appliance.

<!--more-->

Running the Google SDK on the LmP is extremely simple, just run the following docker command and you'll have the demo running in a matter of minutes.

    docker run --rm -it --device /dev/snd \
       -e MIC_ADDR=$MIC_ADDR -e SPEAKER_ADDR=$SPEAKER_ADDR -e PROJECT_ID=$PROJECT_ID \
       -e MODEL_ID=$MODEL_ID -e CLIENT_SECRET=$CLIENT_SECRET -e CLIENT_ID=$CLIENT_ID \
       -e REFRESH_TOKEN=$REFRESH_TOKEN \
       --name ok-google-cli-demo opensourcefoundries/ok-google

Ok, maybe the challenge isn't running the sample, but figuring out the hardware addresses and Google Cloud variables necessary.

    MIC_ADDR="hw:2,0"
    SPEAKER_ADDR="hw:2,0"
    PROJECT_ID=voice-kit-01
    MODEL_ID=voice-kit-01-number2-flc5yj
    CLIENT_ID=7508-5d3.apps.googleusercontent.com
    CLIENT_SECRET=kF4ZLu-X
    REFRESH_TOKEN=1/Ux0k2DAjHYb6jbA

In the rest of this blog, we'll show you where to collect all of these values so that running the Google Assistant will be easy, repeatable and portable.

## Hardware needed

1. Raspberry Pi 3b (others LmP devices will work, but for this demo we'll use the 3b)
   1. All the peripherals (Ethernet cable, 5V micro-usb power, 8GB microSD card)
2. External speaker and Microphone
   1. $85 - [JABRA 510 USB/Bluetooth speaker phone](https://www.amazon.com/Jabra-Wireless-Bluetooth-Softphone-Packaging/dp/B00AQUO5RI) (speaker & mic)
3. Other Hardware tested
   1. $12 - [USHonk USB Speaker](https://www.amazon.com/USHONK-Speaker-Computer-Multimedia-Notebook/dp/B075M7FHM1) (speaker only)
   2. Headphones (speaker only)
   3. $5 - [Kinobo USB mic](https://www.amazon.com/Kinobo-Microphone-Desktop-Recognition-Software/dp/B00IR8R7WQ) (mic only)

## Load the latest Linux microPlatform

Get all the latest software by using the latest microPlatform release. Sign up for a subscription @ [https://app.foundries.io](https://foundries.io "https://app.foundries.io") and download the latest artifacts @ [https://app.foundries.io/mp/lmp/latest/artifacts/](https://app.foundries.io/mp/lmp/latest/artifacts/ "https://app.foundries.io/mp/lmp/latest/artifacts/").

Download a LmP pre-built binary for your Raspberry Pi 3b, write it to a microSD card (using [Resin's Etcher.io project](https://etcher.io/)) or decompress and write it to the flash device using the dd command.

If you are unfamiliar with the Linux microPlatform, more detailed instructions on using the Linux microPlatform can be found at [Documentation on how to install the Linux microPlatform](https://app.foundries.io/docs/latest/tutorial/installation-linux.html)

### 1. Connect to your Raspberry Pi using SSH

    ssh osf@raspberrypi3-64.local

![](/uploads/2018/05/10/connect.png)

### 2. Find your microphone and speaker addresses

In order to route the audio to the right device we will need to find the hardware addresses (and possibly adjust the volume a bit).

1. Plug your device(s) into your Raspberry Pi (we will be using the Jabra Device)
2. Load and run a container that contains the ALSA subsystem (not this also happens to be the container we'll use to run the Google Assistant, but for now we are going to use it only to find the HW device IDs)
   1. Find the microphone device (Note: **Card: 2** and **Device: 0**) (unfortunately, the card ID may may change over reboots)

```
docker run -it --rm --device /dev/snd opensourcefoundries/ok-google arecord -l
setup authorized credentials file
setup alsa configuration
+ exec arecord -l
**** List of CAPTURE Hardware Devices ****
card 2: USB [Jabra SPEAK 510 USB], device 0: USB Audio [USB Audio]
Subdevices: 1/1
Subdevice #0: subdevice #0
```

   2. Find the speaker device (Note: **Card: 2** and **Device: 0**) (unfortunately, the card ID may may change over reboots)

```
docker run -it --rm --device /dev/snd opensourcefoundries/ok-google aplay -l
setup authorized credentials file
setup alsa configuration
+ exec aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: vc4hdmi [vc4-hdmi], device 0: MAI PCM vc4-hdmi-hifi-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: ALSA [bcm2835 ALSA], device 0: bcm2835 ALSA [bcm2835 ALSA]
  Subdevices: 7/7
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
  Subdevice #3: subdevice #3
  Subdevice #4: subdevice #4
  Subdevice #5: subdevice #5
  Subdevice #6: subdevice #6
card 1: ALSA [bcm2835 ALSA], device 1: bcm2835 ALSA [bcm2835 IEC958/HDMI]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: USB [Jabra SPEAK 510 USB], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  ÅSubdevice #0: subdevice #0
```

Now we know that the MIC is **2,0** and the Speaker is **2,0** we will be able to pass this information into the container for further adjustments.  (Note: the card ID may may change over reboots)

1. Test the speaker volume
   1. Note: we pass in MIC_ADDR  and a SPEAKER_ADDR environment variables
   2. Note: we also call the 'speaker-test' utility and run the wav test.  You should hear "Front Left"

```
docker run -it --rm --device /dev/snd -e MIC_ADDR="hw:2,0" -e SPEAKER_ADDR="hw:2,0" opensourcefoundries/ok-google speaker-test -t wav
```

   3. Press CTRL-C to exit
2. Adjust the speaker volume, you can also adjust the MIC gain using the alsamixer application

```
docker run -it --rm --device /dev/snd -e MIC_ADDR="hw:2,0" -e SPEAKER_ADDR="hw:2,0" opensourcefoundries/ok-google alsamixer
  OR
docker run -it --rm --device /dev/snd -e MIC_ADDR="hw:2,0" -e SPEAKER_ADDR="hw:2,0" opensourcefoundries/ok-google alsamixer --card=2 --view=all
```

#### Select the right device (aka Sound Card)

   ![](/uploads/2018/05/09/card.png)

#### Adjust speaker volume

   ![](/uploads/2018/05/09/sp-vol.png)

#### Adjust microphone gain

   ![](/uploads/2018/05/09/mic-vol.png)

After you adjust the volume, you can retest using speaker-test command from step 1 above.

### 3. Authorize your device with the Google Cloud services

Note: Much of this blog was excerpted from Google's SDK documentation at [https://developers.google.com/assistant/sdk/guides/library/python/](https://developers.google.com/assistant/sdk/guides/library/python/ "https://developers.google.com/assistant/sdk/guides/library/python/")

#### Configure an Actions Console project

A Google Cloud Platform project, managed by the Actions Console, gives your device access to the Google Assistant API. The project tracks quota usage and gives you valuable metrics for the requests made from your device.

To enable access to the Google Assistant API, do the following:

1. [Open the Actions Console](https://console.actions.google.com/).
2. Click on Add/import project.
3. To create a new project, type a name in the Project name box and click CREATE PROJECT.
   _If you already have an existing Google Cloud Platform project, you can select that project and import it instead._
4. Click the **Device registration** box.
5. Enable the Google Assistant API on the project you selected (see the [Terms of Service](https://developers.google.com/assistant/sdk/terms-of-service)). You need to do this in the Cloud Platform Console.

     [ENABLE THE API in Console.developers.google.com](https://console.developers.google.com/apis/api/embeddedassistant.googleapis.com/overview)

     Then Click **Enable**.

#### Set activity controls for your account

In order to use the Google Assistant, you must share certain activity data with Google. The Google Assistant needs this data to function properly; this is not specific to the SDK.

Open the [Activity Controls page](https://myaccount.google.com/activitycontrols) for the Google account that you want to use with the Assistant. You can use any Google account, it does not need to be your developer account.

**Ensure the following toggle switches are enabled (blue)**:

* Web & App Activity
  * In addition, be sure to select the **Include Chrome browsing history and activity from websites and apps that use Google services** checkbox.
* Device Information
* Voice & Audio Activity

#### Register the Device Model

Use the registration UI in the Actions Console to register a device model.

1. Open the [Actions Console](https://console.actions.google.com/).
2. Select the project you created previously.
3. Select the **Device registration** tab (under **ADVANCED OPTIONS**) from the left navbar.
4. Click the **REGISTER MODEL** button.

#### Create model

1. Fill out all of the fields for your device.
   See the device model JSON [reference](https://developers.google.com/assistant/sdk/reference/device-registration/model-and-instance-schemas.html#device_model_json) for more information on these fields.
2. When you are finished, click **REGISTER MODEL**

#### Download credentials file

The `credentials.json` file must be located on the device. Later, you will run an authorization tool and reference this file in order to authorize the Google Assistant SDK sample to make Google Assistant queries. Do not rename this file.

Download this file and transfer it to the device.

    scp ~/Downloads/credentials.json osf@raspberrypi3-64.local:/home/osf/

### 4. Run the SDK and Sample code

In the Google samples you would now install software onto your target device, however the container you have been using to query the audio hardware is configured and ready to run the sample with no further modification.

#### Authorize your device

In order to connect your device to the Google services you will first need to generate the appropriate credentials.  We'll do this in a more interactive version using the bash shell and mapping in our credentials.json file from above.

    docker run -it --rm --device /dev/snd -v ${PWD}/credentials.json:/credentials.json opensourcefoundries/ok-google bash
    google-oauthlib-tool --scope https://www.googleapis.com/auth/assistant-sdk-prototype \
              --scope https://www.googleapis.com/auth/gcm \
              --save --headless --client-secrets /credentials.json

Running google-oauthlib-tool will return a HTTPS URL that you will need to copy and paste into your browser to complete the authorization steps.

![](/uploads/2018/05/09/auth-dance.png)

![](/uploads/2018/05/09/code.png)


Copy the authorization code back into your terminal window to complete the authorization dance and get your credentials.

![](/uploads/2018/05/09/copyback.png)


Note three values from your credentials file

    cat /root/.config/google-oauthlib-tool/credentials.json

    {
      "client_secret": "kF4ZLu-X",
      "scopes": [
        "https://www.googleapis.com/auth/assistant-sdk-prototype",
        "https://www.googleapis.com/auth/gcm"
      ],
      "token_uri": "https://accounts.google.com/o/oauth2/token",
      "client_id": "7508-5d3.apps.googleusercontent.com",
      "refresh_token": "1/Ux0k2DAjHYb6jbA"
    }

Now we can exit the container and re-launch it to run the ok-google sample and pass in all of the variables we have discovered.

    MIC_ADDR="hw:2,0"
    SPEAKER_ADDR="hw:2,0"
    PROJECT_ID=voice-kit-01
    MODEL_ID=voice-kit-01-number2-flc5yj
    CLIENT_ID=7508-5d3.apps.googleusercontent.com
    CLIENT_SECRET=kF4ZLu-X
    REFRESH_TOKEN=1/Ux0k2DAjHYb6jbA
    docker run -it --rm --device /dev/snd \
       -e MIC_ADDR=$MIC_ADDR -e SPEAKER_ADDR=$SPEAKER_ADDR -e PROJECT_ID=$PROJECT_ID \
       -e MODEL_ID=$MODEL_ID -e CLIENT_SECRET=$CLIENT_SECRET -e CLIENT_ID=$CLIENT_ID \
       -e REFRESH_TOKEN=$REFRESH_TOKEN \
       --name ok-google-cli-demo opensourcefoundries/ok-google
    setup authorized credentials file
    setup alsa configuration
    + exec bash -c 'googlesamples-assistant-hotword --project_id ${PROJECT_ID}  --device_model_id ${MODEL_ID}'
    device_model_id: voice-kit-01-number2-flc5yj
    device_id: FB5DB23

    https://embeddedassistant.googleapis.com/v1alpha2/projects/voice-kit-01/devices/FB5DB23 404
    Registering....
    Device registered.
    ON_MUTED_CHANGED:
      {'is_muted': False}
    ON_START_FINISHED

    ON_CONVERSATION_TURN_STARTED
    ON_END_OF_UTTERANCE
    ON_RECOGNIZING_SPEECH_FINISHED:
      {'text': 'what time is it'}
    ON_RESPONDING_STARTED:
      {'is_error_response': False}
    ON_RESPONDING_FINISHED
    ON_CONVERSATION_TURN_FINISHED:
      {'with_follow_on_turn': False}

## Extra Credit: Portainer

One you know the necessary variables, you can use our Portainer templates to launch the container.

[How to run Portainer on the Linux microPlatform Blog]({{< relref "/insights/20180508-portainer-container-management-on-linux-microplatform-.md" >}})

#### Open the App Templates and select **OK Google**

![](/uploads/2018/05/09/templates.png)

#### Fill in all the details for the service

![](/uploads/2018/05/09/details.png)

#### The container should be running.

![](/uploads/2018/05/09/running.png)

#### Check the logs

![](/uploads/2018/05/09/logs.png)
