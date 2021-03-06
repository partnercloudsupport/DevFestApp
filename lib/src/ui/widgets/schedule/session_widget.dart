import 'package:devfest_flutter_app/src/models/schedule.dart';
import 'package:devfest_flutter_app/src/models/session.dart';
import 'package:devfest_flutter_app/src/models/speaker.dart';
import 'package:devfest_flutter_app/src/ui/widgets/speakers/speakers_widget.dart';
import 'package:devfest_flutter_app/src/utils/icons.dart';
import 'package:flutter/material.dart';

class SessionView extends StatelessWidget {
  final Session session;
  final Timeslot timeslot;
  final List<Speaker> speakers;

  SessionView(this.timeslot, this.session, this.speakers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: SessionWidget(timeslot, session, speakers)),
    );
  }
}

class BookmarkWidget extends StatefulWidget {
  final Session session;
  final Timeslot timeslot;
  bool isBookmark;

  BookmarkWidget(this.timeslot, this.session, this.isBookmark);

  @override
  _BookmarkWidgetState createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.isBookmark) {
      return FloatingActionButton(
        onPressed: () {
          //_bookmark(timeslot, session, false);
          setState(() {
            widget.isBookmark = false;
          });
        },
        child: Icon(Icons.favorite),
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
          //_bookmark(timeslot, session, true);
          setState(() {
            widget.isBookmark = true;
          });
        },
        child: Icon(Icons.favorite_border),
      );
    }
  }
}

class SessionWidget extends StatelessWidget {
  final Session session;
  final Timeslot timeslot;
  final List<Speaker> speakers;
  SessionWidget(this.timeslot, this.session, this.speakers);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            CoverImageWidget(session.image),
            SafeArea(
                child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white70,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "anim_activity_${session.title}",
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    session.title,
                    textScaleFactor: 2.0,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                timeslot.starttime + " - " + timeslot.endtime,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                session.complexity != null ? session.complexity : '',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 28.0,
              ),
              DescriptionWidget(session),
              SizedBox(
                height: 48.0,
              ),
              SpeakerChipWidget(session, speakers),
            ],
          ),
        ),
      ],
    );
  }
}

class SpeakerChipWidget extends StatelessWidget {
  final Session session;
  final List<Speaker> speakers;
  SpeakerChipWidget(this.session, this.speakers);

  @override
  Widget build(BuildContext context) {
    if (speakers.length > 0) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Text(
          " SPEAKERS",
          textScaleFactor: 1.5,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Column(
            children: speakers
                .map((speaker) => InkWell(
                    onTap: () => _openSpeakerPage(context, speaker),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 24.0,
                        ),
                        Row(
                          children: <Widget>[
                            Hero(
                              tag: "anim_speaker_avatar_${speaker.name}",
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(speaker.photoUrl),
                                minRadius: 35.0,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    speaker.company != ""
                                        ? speaker.name + ", " + speaker.company
                                        : speaker.name,
                                    textScaleFactor: 1.5,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  CommunityChip(speaker),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                      ],
                    )))
                .toList())
      ]);
    } else {
      return Container();
    }
  }

  _openSpeakerPage(BuildContext context, Speaker speaker) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SpeakerViewer(speaker)));
  }
}

class DescriptionWidget extends StatelessWidget {
  final Session session;

  DescriptionWidget(this.session);

  @override
  Widget build(BuildContext context) {
    return ((session.description != null)
        ? Text(
            session.description,
            textAlign: TextAlign.justify,
          )
        : Container());
  }
}

class CommunityChip extends StatelessWidget {
  final Speaker speaker;

  CommunityChip(this.speaker);

  @override
  Widget build(BuildContext context) {
    return ((speaker.badges != null && !speaker.badges.isEmpty)
        ? Row(
            children: speaker.badges
                ?.map((badge) =>
                    IconHelper().getBadgeIcon(badge.name, badge.link))
                ?.toList())
        : Container());
  }
}
