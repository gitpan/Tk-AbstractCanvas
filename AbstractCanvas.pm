#!/usr/bin/perl -w
# 524DkqX - Tk::AbstractCanvas.pm created by Pip Stuart <Pip@CPAN.Org>,
#   derived from Tk::WorldCanvas (by Joseph Skrovan <Joseph@Skrovan.Com>
#    which was based on a version by Rudy Albachten <Rudy@Albachten.Com>)
#            and Tk::RotCanvas   (by Ala Qumsieh <AQumsieh@CPAN.Org>).
# AbstractCanvas provides an alternative to Tk::Canvas with the ability to zoom
#   and rotate.

=head1 NAME

Tk::AbstractCanvas - Canvas with abstract center, zoom, and rotate methods

=head1 VERSION

This documentation refers to version 1.0.56BHMOt of
Tk::AbstractCanvas, which was released on Sat Jun 11 17:22:24:55 2005.

=head1 SYNOPSIS

  #!/usr/bin/perl -w
  use strict;
  use Tk;
  use Tk::AbstractCanvas;

  my $mwin = Tk::MainWindow->new();
  my $acnv = $mwin->AbstractCanvas()->pack(
    '-expand' =>      1,
    '-fill'   => 'both');
  #$acnv->invertY(1); # uncomment for inverted y-axis
  $acnv->controlNav(1); # super Control Navigation
  $acnv->rectToPoly(1);
  #$acnv->ovalToPoly(1);
  my $rect = $acnv->createRectangle( 7, 8, 24, 23,
    '-fill'  =>   'red');
  my $oval = $acnv->createOval(     23, 24, 32, 27,
    '-fill'  => 'green');
  my $line = $acnv->createLine(      0, 1, 31, 32,
    '-fill'  =>  'blue',
    '-arrow' =>  'last');
  my $labl = $mwin->Label('-text' => 'Hello AbstractCanvas! =)');
  my $wind = $acnv->createWindow(15, 16, '-window' => $labl);
  $acnv->CanvasBind('<Button-1>' => sub {
    $acnv->zoom(1.04); } );
  $acnv->CanvasBind('<Button-2>' => sub {
    $acnv->rotate($rect,  5);
    $acnv->rotate($wind,  5); # should do nothing because can't
    $acnv->rotate($oval, -5); #   rotate about center
    $acnv->rotate($line, -5);
  } );
  $acnv->CanvasBind('<Button-3>' => sub {
    $acnv->zoom(0.97); } );
  $acnv->viewAll();
  MainLoop();

=head1 DESCRIPTION

AbstractCanvas provides an alternative to a L<Tk::Canvas> object
which abstracts the coordinates of objects drawn onto the Canvas.
This allows the entire Canvas to be zoomed or rotated.  Rotations
modify the coordinates that the original object was placed at but
zooming the whole canvas does not.

Tk::AbstractCanvas is derived from the excellent modules L<Tk::WorldCanvas>
by Joseph Skrovan <Joseph@Skrovan.Com> (which was itself based on
a version by Rudy Albachten <Rudy@Albachten.Com>) and
L<Tk::RotCanvas> by Ala Qumsieh <AQumsieh@CPAN.Org>.

=head1 2DO

=over 2

=item - abstract full canvas rotations like zoom

=item -    What else does AbstractCanvas need?

=back

=head1 USAGE

=head1 DESCRIPTION

This module is a wrapper around the Canvas widget that maps the
user's coordinate system to the now mostly hidden coordinate system of
the Canvas widget.  There is an option to make the abstract coordinates
y-axis increase in the upward direction.

I<AbstractCanvas> is meant to be a useful alternative to a regular Canvas.
Typically, you should call $abstractcanvas->viewAll() (or
$abstractcanvas->viewArea(@box)) before calling MainLoop().

Most of the I<AbstractCanvas> methods are the same as the I<Canvas>
methods except that they accept and return abstract coordinates instead
of widget coordinates.

I<AbstractCanvas> also adds a new rotate() method to allow rotation of
canvas objects by arbitrary angles.

=head1 NEW METHODS

=over 4

=item I<$abstractcanvas>->B<zoom>(I<zoom factor>)

Zooms the display by the specified amount.  Example:

  $abstractcanvas->CanvasBind('<i>' => sub {$abstractcanvas->zoom(1.25)});
  $abstractcanvas->CanvasBind('<o>' => sub {$abstractcanvas->zoom(0.8)});

  # If you are using the 'Scrolled' constructor as in:
  my $abstractcanvas = $main->Scrolled('AbstractCanvas', -scrollbars => 'nw', ... )
  # you want to bind the key-presses to the 'AbstractCanvas' Subwidget of Scrolled.
  my $scrolled_canvas = $abstractcanvas->Subwidget('abstractcanvas');
  # note the lowercase 'abstractcanvas' above
  $scrolled_canvas->CanvasBind('<i>' => sub {$scrolled_canvas->zoom(1.25)});
  $scrolled_canvas->CanvasBind('<o>' => sub {$scrolled_canvas->zoom(0.8)});

  # If you don't like the scrollbars taking the focus when you
  #   <ctrl>-tab through the windows, you can:
  $abstractcanvas->Subwidget('xscrollbar')->configure(-takefocus => 0);
  $abstractcanvas->Subwidget('yscrollbar')->configure(-takefocus => 0);


=item I<$abstractcanvas>->B<center>(I<x, y>)

Centers the display around abstract coordinates x, y.
Example:

  $abstractcanvas->CanvasBind('<2>' =>
    sub {
      $abstractcanvas->CanvasFocus;
      $abstractcanvas->center($abstractcanvas->eventLocation);
    }
  );


=item I<$abstractcanvas>->B<centerTags>([-exact => {0 | 1}], I<TagOrID, [TagOrID, ...]>)

Centers the display around the center of the bounding box
containing the specified TagOrID's without changing the current
magnification of the display.

'-exact => 1' will cause the canvas to be scaled twice to get
an accurate bounding box.  This will be expensive if the canvas
contains a large number of objects.


=item I<$abstractcanvas>->B<eventLocation>()

Returns the abstract coordinates (x, y) of the last Xevent.


=item I<$abstractcanvas>->B<panAbstract>(I<dx, dy>)

Pans the display by the specified abstract distances.  B<panAbstract>
is not meant to replace the xview/yview panning methods.  Most
user interfaces will want the arrow keys tied to the xview/yview
panning methods (the default bindings), which pan in widget
coordinates.

If you do want to change the arrow key-bindings to pan in abstract
coordinates using B<panAbstract> you must disable the default arrow
key-bindings.

  Example:

  $mainwindow->bind('AbstractCanvas',    '<Up>' => "");
  $mainwindow->bind('AbstractCanvas',  '<Down>' => "");
  $mainwindow->bind('AbstractCanvas',  '<Left>' => "");
  $mainwindow->bind('AbstractCanvas', '<Right>' => "");

  $abstractcanvas->CanvasBind(   '<Up>' => sub {$abstractcanvas->panAbstract(0,  100);});
  $abstractcanvas->CanvasBind( '<Down>' => sub {$abstractcanvas->panAbstract(0, -100);});
  $abstractcanvas->CanvasBind( '<Left>' => sub {$abstractcanvas->panAbstract(-100, 0);});
  $abstractcanvas->CanvasBind('<Right>' => sub {$abstractcanvas->panAbstract( 100, 0);});

This is not usually desired, as the percentage of the display that
is shifted will be dependent on the current display magnification.


=item I<$abstractcanvas>-E<gt>B<invertY>([new_value])

Returns the state of whether the abstract coordinates y-axis is inverted.
The default of this value is 0.  An optional parameter can be supplied to
set the value.

I guess all these options are not so private now that they have accessors.
I'm not sure where better to store them than privateData though.


=item I<$abstractcanvas>-E<gt>B<rectToPoly>([new_value])

Returns the state of whether created rectangles should be auto-converted
to polygons (so that they can be rotated about their center by the
rotate() method).  The default of this value is 0.  An optional parameter
can be supplied to set the value.


=item I<$abstractcanvas>-E<gt>B<ovalToPoly>([new_value])

Returns the state of whether created ovals should be auto-converted
to polygons (so that they can be rotated about their center by the
rotate() method).  The default of this value is 0.  An optional parameter
can be supplied to set the value.


=item I<$abstractcanvas>-E<gt>B<controlNav>([new_value])

Returns the state of whether special Control+MouseButton bindings are set.
When true, Control-Button-1 then dragging the mouse rotates the whole
AbstractCanvas, 2 pans, and 3 zooms.  The default of this value is 0 but this
option is very useful if you don't need Control-Button bindings for some
other purpose.  An optional parameter can be supplied to set the value.


=item I<$abstractcanvas>-E<gt>B<controlNavBusy>([new_value])

Returns the state of whether special Control+MouseButton actions are
busy.  An optional parameter can be supplied to set the value.


=item I<$abstractcanvas>-E<gt>B<controlZoomScale>([new_value])

Returns the value of the special controlNav zoom scale (activated by
Control-Button-3).  The default value is -0.001.  The zoom function takes
the distance dragged in pixels across the positive x and y axes scaled by
the zoom scale to determine the zoom result.  If you make the scale
positive, it will invert the directions which zoom in and out.  If you
make the number larger (e.g., -0.003 or 0.003), zooming will become more
twitchy.  If you make the number smaller (e.g., -0.0007 or 0.0007), zooming
will happen more smoothly.  An optional parameter can be supplied to
set the value.


=item I<$abstractcanvas>-E<gt>B<controlRotScale>([new_value])

Returns the value of the special controlNav rotation scale (activated by
Control-Button-1).  The default value is -0.3.  The zoom function takes
the distance dragged in pixels across the positive x and y axes scaled by
the rotation scale to determine the rotation result.  If you make the
scale positive, it will invert the directions which rotate positive or
negative degrees.  If you make the number larger (e.g., -0.7 or 0.7),
rotations will become more twitchy.  If you make the number smaller
(e.g., -0.07 or 0.07), rotations will happen more smoothly.  An optional
parameter can be supplied to set the value.


=item I<$abstractcanvas>-E<gt>B<controlScale>([new_value])

Returns the underlying scale value of the abstract canvas relative to
the underlying canvas.  An optional parameter can be supplied to set the
value although the zoom function should almost always be employed
instead of manipulating the scale through this accessor.


=item I<$abstractcanvas>-E<gt>B<eventX>([new_value])

Returns the x-coordinate of where the last special Control+MouseButton
event occurred.  An optional parameter can be supplied to set the value.


=item I<$abstractcanvas>-E<gt>B<eventY>([new_value])

Returns the y-coordinate of where the last special Control+MouseButton
event occurred.  An optional parameter can be supplied to set the value.


=item I<$abstractcanvas>-E<gt>B<rotate>(I<TagOrID, angle> ?,I<x, y>?)

This method rotates the object identified by TagOrID by an angle I<angle>.
The angle is specified in I<degrees>. If a coordinate is specified, then
the object is rotated about that point.  Otherwise, the object is rotated
about its center of mass if that is possible.


=item I<$abstractcanvas>->B<pixelSize>()

Returns the width (in abstract coordinates) of a pixel (at the current magnification).


=item I<$abstractcanvas>->B<rubberBand>(I<{0|1|2}>)

Creates a rubber banding box that allows the user to graphically
select a region.  B<rubberBand> is called with a step parameter
'0', '1', or '2'.  '0' to start a new box, '1' to stretch the box,
and '2' to finish the box.  When called with '2', the specified
box is returned (x1, y1, x2, y2)

The band color is set with the I<AbstractCanvas> option '-bandColor'.
The default color is 'red'

  Example, specify a region to delete:

  $abstractcanvas->configure(-bandColor => 'purple');
  $abstractcanvas->CanvasBind('<3>'               => sub {$abstractcanvas->CanvasFocus;
                                                       $abstractcanvas->rubberBand(0)
                                                      });
  $abstractcanvas->CanvasBind('<B3-Motion>'       => sub {$abstractcanvas->rubberBand(1)});
  $abstractcanvas->CanvasBind('<ButtonRelease-3>' => sub {my @box = $abstractcanvas->rubberBand(2);
                                                       my @ids = $abstractcanvas->find('enclosed', @box);
                                                       foreach my $id (@ids) {$abstractcanvas->delete($id)}
                                                      });
  # Note: '<B3-ButtonRelease>' will be called for any ButtonRelease!
  # You should use '<ButtonRelease-3>' instead.

  # If you want the rubber band to look smooth during panning and
  # zooming, add rubberBand(1) update calls to the appropriate key-bindings:

  $abstractcanvas->CanvasBind(   '<Up>' => sub {$abstractcanvas->rubberBand(1);});
  $abstractcanvas->CanvasBind( '<Down>' => sub {$abstractcanvas->rubberBand(1);});
  $abstractcanvas->CanvasBind( '<Left>' => sub {$abstractcanvas->rubberBand(1);});
  $abstractcanvas->CanvasBind('<Right>' => sub {$abstractcanvas->rubberBand(1);});
  $abstractcanvas->CanvasBind('<i>' => sub {$abstractcanvas->zoom(1.25); $abstractcanvas->rubberBand(1);});
  $abstractcanvas->CanvasBind('<o>' => sub {$abstractcanvas->zoom(0.8);  $abstractcanvas->rubberBand(1);});

This box avoids the overhead of bounding box calculations
that can occur if you create your own rubberBand outside of I<AbstractCanvas>.


=item I<$abstractcanvas>->B<viewAll>([-border => number])

Displays at maximum possible zoom all objects centered in the
I<AbstractCanvas>.  The switch '-border' specifies, as a percentage
of the screen, the minimum amount of white space to be left on
the edges of the display.  Default '-border' is 0.02.


=item I<$abstractcanvas>->B<viewArea>(x1, y1, x2, y2, [-border => number]))

Displays at maximum possible zoom the specified region centered
in the I<AbstractCanvas>.


=item I<$abstractcanvas>->B<viewFit>([-border => number], I<TagOrID>, [I<TagOrID>, ...])

Adjusts the AbstractCanvas to display all of the specified tags.  The '-border'
switch specifies (as a percentage) how much extra surrounding space should be shown.


=item I<$abstractcanvas>->B<getView>()

Returns the rectangle of the current view (x1, y1, x2, y2)


=item I<$abstractcanvas>->B<widgetx>(I<x>)

=item I<$abstractcanvas>->B<widgety>(I<y>)

=item I<$abstractcanvas>->B<widgetxy>(I<x, y>)

Convert abstract coordinates to widget coordinates.


=item I<$abstractcanvas>->B<abstractx>(I<x>)

=item I<$abstractcanvas>->B<abstracty>(I<y>)

=item I<$abstractcanvas>->B<abstractxy>(I<x, y>)

Convert widget coordinates to abstract coordinates.

=back

=head1 CHANGED METHODS

=over 4

Abstract coordinates are supplied and returned to B<AbstractCanvas> methods
instead of widget coordinates unless otherwise specified.  (i.e., These
methods take and return abstract coordinates: center, panAbstract, viewArea,
find, coords, scale, move, bbox, rubberBand, eventLocation, pixelSize,
and create*)


=item I<$abstractcanvas>->B<bbox>([-exact => {0 | 1}], I<TagOrID>, [I<TagOrID>, ...])

'-exact => 1' is only needed if the TagOrID is not 'all'.  It
will cause the canvas to be scaled twice to get an accurate
bounding box.  This will be expensive if the canvas contains
a large number of objects.

Neither setting of exact will produce exact results because
the underlying canvas bbox method returns a slightly larger box
to insure that everything is contained.  It appears that a number
close to '2' is added or subtracted.  The '-exact => 1' zooms
in to reduce this error.

If the underlying canvas B<bbox> method returns a bounding box
that is small (high error percentage) then '-exact => 1' is done
automatically.


=item I<$abstractcanvas>->B<scale>(I<'all', xOrigin, yOrigin, xScale, yScale>)

B<Scale> should not be used to 'zoom' the display in and out as it will
change the abstract coordinates of the scaled objects.  Methods B<zoom>,
B<viewArea>, and B<viewAll> should be used to change the
scale of the display without affecting the dimensions of the objects.

=back

=head1 VIEW AREA CHANGE CALLBACK

I<Tk::AbstractCanvas> option '-changeView' can be used to specify
a callback for a change of the view area.  This is useful for
updating a second AbstractCanvas which is displaying the view region
of the first AbstractCanvas.

The callback subroutine will be passed the coordinates of the
displayed box (x1, y1, x2, y2).  These arguments are added after
any extra arguments specifed by the user calling 'configure'.

  Example:

  $abstractcanvas->configure(-changeView => [\&changeView, $abstractcanvas2]);
  # viewAll if AbstractCanvas2 widget is resized.
  $abstractcanvas2->CanvasBind('<Configure>' => sub {$abstractcanvas2->viewAll});
  {
    my $viewBox;
    sub changeView {
      my ($canvas2, @coords) = @_;
      $canvas2->delete($viewBox) if $viewBox;
      $viewBox = $canvas2->createRectangle(@coords, -outline => 'orange');
    }
  }


=head1 SCROLL REGION NOTES

(1) The underlying I<Tk::Canvas> has a '-confine' option which is set
to '1' by default.  With '-confine => 1' the canvas will not allow
the display to go outside of the scroll region causing some methods
to not work accurately.  For example, the 'center' method will not be
able to center on coordinates near to the edge of the scroll region;
'zoom out' near the edge will zoom out and pan towards the center.

I<Tk::AbstractCanvas> sets '-confine => 0' by default to avoid these
problems.  You can change it back with:

    $abstractcanvas->configure(-confine => 1);


(2) '-scrollregion' is maintained by I<AbstractCanvas> to include all
objects on the canvas.  '-scrollregion' will be adjusted automatically
as objects are added, deleted, scaled, moved, etc.  (You can create a
static scrollregion by adding a border rectangle to the canvas.)


(3) The bounding box of all objects is required to set the scroll region.
Calculating this bounding box is expensive if the canvas has a large
number of objects.  So for performance reasons these operations will
not immediately change the bounding box if they potentially shrink it:

  coords
  delete
  move
  scale

Instead they will mark the bounding box as invalid, and it will be
updated at the next zoom or pan operation.  The only downside to this
is that the scrollbars will be incorrect until the update.

If these operations increase the size of the box, changing the box is
trivial and the update is immediate.

=head1 ROTATION LIMITATIONS

As it stands, the module can only rotate the following object types
about their centers:

=over 4

=item * Lines

=item * Polygons

=item * Rectangles (if rectToPoly(1) is called)

=item * Ovals      (if ovalToPoly(1) is called)

=back

All other object types (bitmap, image, arc, text, and window) can only
be rotated about another point.  A warning is issued if the user tries
to rotate one of these object types about their center. Hopefully,
more types will be able to center-rotate in the future.

=head1 ROTATION DETAILS

To be able to rotate rectangles and ovals, this module is capable of
intercepting any calls to B<create()>, B<createRectangle()>, and
B<createOval()> to change them to polygons.  The user should not be
alarmed if B<type()> returns I<polygon> when a I<rectangle> or I<oval>
was expected.  Additionally, if you call B<coords()> on a polygonized
object, expect to have to manipulate all the additionally generated
coordinates.

=head1 CHANGES

Revision history for Perl extension Tk::AbstractCanvas:

=over 4

=item - 1.0.56BHMOt  Sat Jun 11 17:22:24:55 2005

* original version

=back

=head1 INSTALL

Please run:

    `perl -MCPAN -e "install Tk::AbstractCanvas"`

or uncompress the package and run the standard:

    `perl Makefile.PL;       make;       make test;       make install`
      or if you don't have `make` but Module::Build is installed
    `perl    Build.PL; perl Build; perl Build test; perl Build install`

=head1 LICENSE

Most source code should be Free!
  Code I have lawful authority over is and shall be!
Copyright: (c) 2005, Pip Stuart.
Copyleft :  This software is licensed under the GNU General Public
  License (version 2).  Please consult the Free Software Foundation
  (http://FSF.Org) for important information about your freedom.

=head1 AUTHORS

Pip Stuart (I<Pip@CPAN.Org>)

AbstractCanvas is derived from code by:
Joseph Skrovan (I<Joseph@Skrovan.Com>)
Rudy Albachten (I<Rudy@Albachten.Com>)
Ala Qumsieh    (I<AQumsieh@CPAN.Org>)

=cut

package Tk::AbstractCanvas;
require Tk::Derived;
require Tk::Canvas;
use strict;
use Tk;
use Carp;
our $VERSION     = '1.0.56BHMOt'; # major . minor . PipTimeStamp
our $PTVR        = $VERSION; $PTVR =~ s/^\d+\.\d+\.//; # strip major and minor
# Please see `perldoc Time::PT` for an explanation of $PTVR.

@Tk::AbstractCanvas::ISA = qw(Tk::Derived Tk::Canvas);

Construct Tk::Widget 'AbstractCanvas';

# If objects can't rotate about their center, their center can at least
#   rotate about another point on the canvas.
my %_can_rotate_about_center = (
  line      => 1,
  polygon   => 1,
);

my %_rotate_methods = (
  line      => \&_rotate_line,
  text      => \&_rotate_line,
  image     => \&_rotate_line,
  bitmap    => \&_rotate_line,
  window    => \&_rotate_line,
  rectangle => \&_rotate_rect,
  arc       => \&_rotate_rect,
  grid      => \&_rotate_rect,
  oval      => \&_rotate_rect,
  polygon   => \&_rotate_poly,
);

use constant PI => 3.14159269;

sub ClassInit {
  my($acnv, $mwin)= @_;
  $acnv->SUPER::ClassInit($mwin);
}

sub InitObject {
  my($acnv, $args)= @_;
  my $pdat = $acnv->privateData();
  $pdat->{'bbox'              } = [0, 0, -1, -1];
  $pdat->{'scale'             } = 1;
  $pdat->{'movex'             } = 0;
  $pdat->{'movey'             } = 0;
  $pdat->{'bboxvalid'         } = 1;
  $pdat->{'inverty'           } = 0;
  $pdat->{'rect_to_poly'      } = 0;
  $pdat->{'oval_to_poly'      } = 0;
  $pdat->{'control_nav'       } = 0;
  $pdat->{'control_nav_busy'  } = 0; # flag to know not to allow other navs
  $pdat->{'control_rot_scale' } = -0.3;
  $pdat->{'control_zoom_scale'} = -0.001;
  $pdat->{'eventx'            } = -1;
  $pdat->{'eventy'            } = -1;
  $pdat->{'width'             } = $acnv->width();
  $pdat->{'height'            } = $acnv->height();
  $acnv->configure(-confine => 0);
  $acnv->ConfigSpecs(
    '-bandColor'  => ['PASSIVE',  'bandColor',  'BandColor', 'red' ],
    '-bandcolor'  => '-bandColor',
    '-changeView' => ['CALLBACK', 'changeView', 'ChangeView', undef],
    '-changeview' => '-changeView');
  $acnv->CanvasBind('<Configure>' => sub {
    my $widt = $acnv->width();
    my $hite = $acnv->height();
    my $pwid = $pdat->{'width' };
    my $phit = $pdat->{'height'};
    if($widt != $pwid || $hite != $phit) {
      my $bwid = $acnv->cget('-borderwidth');
      _view_area_canvas($acnv, $bwid, $bwid, $pwid - $bwid, $phit - $bwid);
      $pdat->{'width' } = $widt;
      $pdat->{'height'} = $hite;
      my $bbox = $pdat->{'bbox'};
      my $left = $acnv->canvasx($bwid);
      my $rite = $acnv->canvasx($widt - $bwid);
      my $topp = $acnv->canvasy($bwid);
      my $botm = $acnv->canvasy($hite - $bwid);
      $acnv->viewAll() if(_inside(@$bbox, $left, $topp, $rite, $botm));
    }
  });
  $acnv->SUPER::InitObject($args);
}

sub invertY {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'inverty'} = shift() if(@_);
  return($pdat->{'inverty'});
}

sub rectToPoly {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'rect_to_poly'} = shift() if(@_);
  return($pdat->{'rect_to_poly'});
}

sub ovalToPoly {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'oval_to_poly'} = shift() if(@_);
  return($pdat->{'oval_to_poly'});
}

sub controlNav {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  if(@_) {
    $pdat->{'control_nav'} = shift();
    if($pdat->{'control_nav'}) {
      $acnv->CanvasBind('<Control-Button-1>' => sub {
        if($pdat->{'eventx'} == -1 && $pdat->{'eventy'} == -1 &&
          !$pdat->{'control_nav_busy'}) {
          $pdat->{'control_nav_busy'} = 1;
          ($pdat->{'eventx'}, $pdat->{'eventy'}) = $acnv->eventLocation();
          $acnv->CanvasBind('<Motion>' => sub {
            my($evtx, $evty)= $acnv->eventLocation();
            my($left, $botm, $rite, $topp)= $acnv->getView();
            my($cntx, $cnty)= (($left + $rite) / 2, ($botm + $topp) / 2);
            foreach($acnv->find('all')) {
              $acnv->rotate($_, (($pdat->{'eventx'} - $evtx) +
                                 ($pdat->{'eventy'} - $evty)) *
                                  $pdat->{'control_rot_scale'} *
                                  $pdat->{'scale'}, $cntx, $cnty);
            }
            ($pdat->{'eventx'}, $pdat->{'eventy'}) = ($evtx, $evty);
          });
          $acnv->CanvasBind('<ButtonRelease-1>' => sub {
            my($evtx, $evty)= $acnv->eventLocation();
            my($left, $botm, $rite, $topp)= $acnv->getView();
            my($cntx, $cnty)= (($left + $rite) / 2, ($botm + $topp) / 2);
            foreach($acnv->find('all')) {
              $acnv->rotate($_, (($pdat->{'eventx'} - $evtx) +
                                 ($pdat->{'eventy'} - $evty)) *
                                  $pdat->{'control_rot_scale'} *
                                  $pdat->{'scale'}, $cntx, $cnty);
            }
            ($pdat->{'eventx'}, $pdat->{'eventy'}) = (-1, -1);
            $pdat->{'control_nav_busy'} = 0;
            $acnv->CanvasBind('<Motion>'          => '');
            $acnv->CanvasBind('<ButtonRelease-1>' => '');
          });
        }
      });
      $acnv->CanvasBind('<Control-Button-2>' => sub {
        if($pdat->{'eventx'} == -1 && $pdat->{'eventy'} == -1 &&
          !$pdat->{'control_nav_busy'}) {
          $pdat->{'control_nav_busy'} = 1;
          ($pdat->{'eventx'}, $pdat->{'eventy'}) = $acnv->eventLocation();
          $acnv->CanvasBind('<Motion>' => sub {
            my($evtx, $evty)= $acnv->eventLocation();
            $acnv->panAbstract($pdat->{'eventx'} - $evtx,
                            $pdat->{'eventy'} - $evty);
            ($pdat->{'eventx'}, $pdat->{'eventy'}) = $acnv->eventLocation();
          });
          $acnv->CanvasBind('<ButtonRelease-2>' => sub {
            my($evtx, $evty)= $acnv->eventLocation();
            $acnv->panAbstract($pdat->{'eventx'} - $evtx,
                            $pdat->{'eventy'} - $evty);
            ($pdat->{'eventx'}, $pdat->{'eventy'}) = (-1, -1);
            $pdat->{'control_nav_busy'} = 0;
            $acnv->CanvasBind('<Motion>'          => '');
            $acnv->CanvasBind('<ButtonRelease-2>' => '');
          });
        }
      });
      $acnv->CanvasBind('<Control-Button-3>' => sub {
        if($pdat->{'eventx'} == -1 && $pdat->{'eventy'} == -1 &&
          !$pdat->{'control_nav_busy'}) {
          $pdat->{'control_nav_busy'} = 1;
          ($pdat->{'eventx'}, $pdat->{'eventy'}) = $acnv->eventLocation();
          $acnv->CanvasBind('<Motion>' => sub {
            my($evtx, $evty)= $acnv->eventLocation();
            $acnv->zoom(1.0 + (($pdat->{'eventx'} - $evtx) +
                               ($pdat->{'eventy'} - $evty)) *
                                $pdat->{'control_zoom_scale'} *
                                $pdat->{'scale'});
            ($pdat->{'eventx'}, $pdat->{'eventy'}) = ($evtx, $evty);
          });
          $acnv->CanvasBind('<ButtonRelease-3>' => sub {
            my($evtx, $evty)= $acnv->eventLocation();
            $acnv->zoom(1.0 + (($pdat->{'eventx'} - $evtx) +
                               ($pdat->{'eventy'} - $evty)) *
                                $pdat->{'control_zoom_scale'} *
                                $pdat->{'scale'});
            ($pdat->{'eventx'}, $pdat->{'eventy'}) = (-1, -1);
            $pdat->{'control_nav_busy'} = 0;
            $acnv->CanvasBind('<Motion>'          => '');
            $acnv->CanvasBind('<ButtonRelease-3>' => '');
          });
        }
      });
    } else {
      $acnv->CanvasBind('<Control-Button-1>' => '');
      $acnv->CanvasBind('<Control-Button-2>' => '');
      $acnv->CanvasBind('<Control-Button-3>' => '');
    }
  }
  return($pdat->{'control_nav'});
}

sub controlNavBusy {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'control_nav_busy'} = shift() if(@_);
  return($pdat->{'control_nav_busy'});
}

sub controlZoomScale {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'control_zoom_scale'} = shift() if(@_);
  return($pdat->{'control_zoom_scale'});
}

sub controlRotScale {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'control_rot_scale'} = shift() if(@_);
  return($pdat->{'control_rot_scale'});
}

sub controlScale {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'scale'} = shift() if(@_);
  return($pdat->{'scale'});
}

sub eventX {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'eventx'} = shift() if(@_);
  return($pdat->{'eventx'});
}

sub eventY {
  my $acnv = shift();
  my $pdat = $acnv->privateData();
  $pdat->{'eventy'} = shift() if(@_);
  return($pdat->{'eventy'});
}

# This is the new rotate() method. It takes as input the
#   id of the object to rotate, and the angle to rotate it with.
# It then rotates the object about its center or the given x,y point
#   by the given angle
sub rotate {
  my($self, $obid, $angl, $xfoc, $yfoc)= @_;
  croak "rotate: Must supply an angle -" unless(defined($angl));
  my $type = $self->type($obid);
  # Some need a pivot point to rotate their center around.
  return() unless(exists($_can_rotate_about_center{$type}) ||
                 (defined($xfoc) && defined($yfoc)));
  $_rotate_methods{$type}->($self, $obid, $angl, $xfoc, $yfoc);
}

sub _rotate_line {
  my($self, $obid, $angl, $xmid, $ymid)= @_;
  my @crds = $self->coords($obid); # Get the old coordinates.
  # If the center of rotation is not given, get the default.
  # Get the center of the line. We use this to translate the
  #   above coords back to the origin, and then rotate about
  #   the origin, then translate back.
  unless(defined($xmid)) {
    $xmid = $crds[0] + 0.5*($crds[2] - $crds[0]);
    $ymid = $crds[1] + 0.5*($crds[3] - $crds[1]);
  }
  my @newc;
  my $radi = PI * $angl / 180.0;
  my $sine = sin($radi);
  my $cosi = cos($radi);
  # Calculate the new coordinates of the line.
  while(my($xcrd, $ycrd)= splice(@crds, 0, 2)) {
    my $xnew = $xcrd - $xmid;
    my $ynew = $ycrd - $ymid;
    push(@newc, $xmid + ($xnew * $cosi - $ynew * $sine));
    push(@newc, $ymid + ($xnew * $sine + $ynew * $cosi));
  }
  $self->coords($obid, @newc); # Redraw the line.
}

sub _rotate_poly {
  my($self, $obid, $angl, $xmid, $ymid)= @_;
  my @crds = $self->coords($obid); # Get the old coordinates.
  # Get the center of the poly. We use this to translate the
  #   above coords back to the origin, and then rotate about
  #   the origin, then translate back. (old)
  ($xmid, $ymid) = _get_CM(@crds) unless(defined($xmid));
  my @newc;
  my $radi = PI * $angl / 180.0;
  my $sine = sin($radi);
  my $cosi = cos($radi);
  # Calculate the new coordinates of the poly.
  while(my($xcrd, $ycrd)= splice(@crds, 0, 2)) {
    my $xnew = $xcrd - $xmid;
    my $ynew = $ycrd - $ymid;
    push(@newc, $xmid + ($xnew * $cosi - $ynew * $sine));
    push(@newc, $ymid + ($xnew * $sine + $ynew * $cosi));
  }
  $self->coords($obid, @newc); # Redraw the poly.
}

sub _rotate_rect { # special rectangle rotation just for center
  my($self, $obid, $angl, $xmid, $ymid)= @_;
  my @crds = $self->coords($obid); # Get the old coordinates.
  # Get the center of the poly. We use this to translate the
  # above coords back to the origin, and then rotate about
  # the origin, then translate back. (old)
  my($xomd, $yomd)= (($crds[0] + $crds[2]) / 2,
                     ($crds[1] + $crds[3]) / 2); # original midpoint
    ($xmid, $ymid)= ($xomd, $yomd) unless(defined($xmid));
  my @newc;
  my $radi = PI * $angl / 180.0;
  my $sine = sin($radi);
  my $cosi = cos($radi);
  # Calculate the new coordinates of the midpoint.
  my $xnew = $xomd - $xmid;
  my $ynew = $yomd - $ymid;
  my $xrmd = $xmid + ($xnew * $cosi - $ynew * $sine);
  my $yrmd = $ymid + ($xnew * $sine + $ynew * $cosi);
  while(my($xcrd, $ycrd)= splice(@crds, 0, 2)) {
    push(@newc, ($xcrd - $xomd) + $xrmd);
    push(@newc, ($ycrd - $yomd) + $yrmd);
  }
  $self->coords($obid, @newc); # Redraw the poly.
}

sub getView {
  my($cnvs)= @_;
  my $bwid = $cnvs->cget('-borderwidth');
  my $left = $bwid;
  my $rite = $cnvs->width()  - $bwid;
  my $topp = $bwid;
  my $botm = $cnvs->height() - $bwid;
  return(abstractxy($cnvs, $left, $topp), abstractxy($cnvs, $rite, $botm));
}

sub xview {
  my $cnvs = shift();
  _new_bbox($cnvs) unless($cnvs->privateData->{'bboxvalid'});
  $cnvs->SUPER::xview(@_);
  $cnvs->Callback('-changeView' => getView($cnvs)) if(defined($cnvs->cget('-changeView')));
}

sub yview {
  my $cnvs = shift();
  _new_bbox($cnvs) unless($cnvs->privateData->{'bboxvalid'});
  $cnvs->SUPER::yview(@_);
  $cnvs->Callback('-changeView' => getView($cnvs)) if(defined($cnvs->cget('-changeView')));
}

sub delete {
  my($cnvs, @tags)= @_;
  my $recr = _killBand($cnvs); # recreate
  my $foun = 0;
  foreach(@tags) {
    if($cnvs->type($_)) { $foun = 1; last(); }
  }
  unless($foun) { _makeBand($cnvs) if($recr); return(); }
  my $pdat = $cnvs->privateData();
  my($pbx1, $pby1, $pbx2, $pby2)= @{$pdat->{'bbox'}};
  my($cbx1, $cby1, $cbx2, $cby2)= _superBbox($cnvs, @tags);
  $cnvs->SUPER::delete(@tags);
  if(!$cnvs->type('all')) {  # deleted last object
    $pdat->{'bbox' } = [0, 0, -1, -1];
    $pdat->{'scale'} = 1;
    $pdat->{'movex'} = 0;
    $pdat->{'movey'} = 0;
  } elsif(!_inside($cbx1, $cby1, $cbx2, $cby2, $pbx1, $pby1, $pbx2, $pby2)) {
    $pdat->{'bboxvalid'} = 0;
  }
  _makeBand($cnvs) if($recr);
}

sub _inside {
  my($pbx1, $pby1, $pbx2, $pby2, $cbx1, $cby1, $cbx2, $cby2)= @_;
  my $wmrg = 0.01 * ($cbx2 - $cbx1); $wmrg = 3 if($wmrg < 3); # width  margin
  my $hmrg = 0.01 * ($cby2 - $cby1); $hmrg = 3 if($hmrg < 3); # height margin
  return($pbx1 - $wmrg > $cbx1 && $pby1 - $hmrg > $cby1 &&
         $pbx2 + $wmrg < $cbx2 && $pby2 + $hmrg < $cby2);
}

sub _new_bbox {
  my($cnvs)= @_;
  my $bwid = $cnvs->cget('-borderwidth');
  my $vwid = $cnvs->width()  - 2 * $bwid;
  my $vhit = $cnvs->height() - 2 * $bwid;
  my $pdat = $cnvs->privateData();
  my($pbx1, $pby1, $pbx2, $pby2)= @{$pdat->{'bbox'}};
  $pbx2++ if($pbx2 == $pbx1);
  $pby2++ if($pby2 == $pby1);
  my $zumx = $vwid / abs($pbx2 - $pbx1);
  my $zumy = $vhit / abs($pby2 - $pby1);
  my $zoom =($zumx > $zumy) ? $zumx : $zumy;
  if($zoom > 1.01) {
    _scale($cnvs, $cnvs->width() / 2, $cnvs->height() / 2, $zoom * 100);
  }
  my($cbx1, $cby1, $cbx2, $cby2)= _superBbox($cnvs, 'all');
  $pdat->{'bbox'} =                   [$cbx1, $cby1, $cbx2, $cby2];
  $cnvs->configure('-scrollregion' => [$cbx1, $cby1, $cbx2, $cby2]);
  if($zoom > 1.01) {
    _scale($cnvs, $cnvs->width() / 2, $cnvs->height() / 2, 1 / ($zoom * 100));
  }
  $pdat->{'bboxvalid'} = 1;
}

sub _find_box {
  die "Error: the number of args to _find_box must be positive and even\n" if @_ % 2 or !@_;
  my($fbx1, $fbx2, $fby1, $fby2)=($_[0], $_[0], $_[1], $_[1]);
  for(my $indx = 2; $indx < @_; $indx += 2) {
    $fbx1 = $_[$indx    ] if($_[$indx    ] < $fbx1);
    $fbx2 = $_[$indx    ] if($_[$indx    ] > $fbx2);
    $fby1 = $_[$indx + 1] if($_[$indx + 1] < $fby1);
    $fby2 = $_[$indx + 1] if($_[$indx + 1] > $fby2);
  }
  return($fbx1, $fby1, $fbx2, $fby2);
}

sub zoom {
  my($cnvs, $zoom)= @_;
  _new_bbox($cnvs) unless($cnvs->privateData->{'bboxvalid'});
  _scale($cnvs, $cnvs->width() / 2, $cnvs->height() / 2, $zoom);
  $cnvs->Callback('-changeView' => getView($cnvs)) if(defined($cnvs->cget('-changeView')));
}

sub _scale {
  my($cnvs, $xoff, $yoff, $scal)= @_;
  $scal = abs($scal);
  my $xval = $cnvs->canvasx(0) + $xoff;
  my $yval = $cnvs->canvasy(0) + $yoff;
  return() unless($cnvs->type('all'));
  my $pdat = $cnvs->privateData();
  $pdat->{'movex'} = ($pdat->{'movex'} - $xval) * $scal + $xval;
  $pdat->{'movey'} = ($pdat->{'movey'} - $yval) * $scal + $yval;
  $pdat->{'scale'} *= $scal;
  $cnvs->SUPER::scale('all', $xval, $yval, $scal, $scal);
  my($pbx1, $pby1, $pbx2, $pby2)= @{$pdat->{'bbox'}};
  $pbx1 = ($pbx1 - $xval) * $scal + $xval;
  $pbx2 = ($pbx2 - $xval) * $scal + $xval;
  $pby1 = ($pby1 - $yval) * $scal + $yval;
  $pby2 = ($pby2 - $yval) * $scal + $yval;
  $pdat->{'bbox'} =                   [$pbx1, $pby1, $pbx2, $pby2];
  $cnvs->configure('-scrollregion' => [$pbx1, $pby1, $pbx2, $pby2]);
}

sub center {
  my($cnvs, $xval, $yval)= @_;
  return() unless($cnvs->type('all'));
  my $pdat = $cnvs->privateData();
  _new_bbox($cnvs) unless($pdat->{'bboxvalid'});
  $xval = $xval * $pdat->{'scale'} + $pdat->{'movex'};
  if($pdat->{'inverty'}) {
    $yval = $yval * -$pdat->{'scale'} + $pdat->{'movey'};
  } else {
    $yval = $yval *  $pdat->{'scale'} + $pdat->{'movey'};
  }
  my $xdlt = $cnvs->canvasx(0) + $cnvs->width()  / 2 - $xval;
  my $ydlt = $cnvs->canvasy(0) + $cnvs->height() / 2 - $yval;
  $pdat->{'movex'} += $xdlt;
  $pdat->{'movey'} += $ydlt;
  $cnvs->SUPER::move('all', $xdlt, $ydlt);
  my($pbx1, $pby1, $pbx2, $pby2) = @{$pdat->{'bbox'}};
  $pbx1 += $xdlt;
  $pbx2 += $xdlt;
  $pby1 += $ydlt;
  $pby2 += $ydlt;
  $pdat->{'bbox'} =                   [$pbx1, $pby1, $pbx2, $pby2];
  $cnvs->configure('-scrollregion' => [$pbx1, $pby1, $pbx2, $pby2]);
  $cnvs->Callback('-changeView' => getView($cnvs)) if(defined($cnvs->cget('-changeView')));
}

sub centerTags {
  my($cnvs, @args)= @_;
  my($cbx1, $cby1, $cbx2, $cby2)= bbox($cnvs, @args);
  return() unless(defined($cby2));
  center($cnvs, ($cbx1 + $cbx2) / 2.0, ($cby1 + $cby2) / 2.0);
}

sub panAbstract {
  my($cnvs, $xval, $yval) = @_;
  my $cnvx = abstractx($cnvs, $cnvs->width()  / 2) + $xval;
  my $cnvy = abstracty($cnvs, $cnvs->height() / 2) + $yval;
  center($cnvs, $cnvx, $cnvy);
}

sub viewAll {
  my $cnvs = shift();
  return() unless($cnvs->type('all'));
  my %swch = ('-border' => 0.02, @_);
  $swch{'-border'} = 0 if($swch{'-border'} < 0);
  my $pdat = $cnvs->privateData();
  _new_bbox($cnvs) unless($pdat->{'bboxvalid'});
  my($pbx1, $pby1, $pbx2, $pby2)= @{$pdat->{'bbox'}};
  my $scal = $pdat->{'scale'};
  my $movx = $pdat->{'movex'}; my $movy = $pdat->{'movey'};
  my $wnx1 = ($pbx1 - $movx) / $scal; my $wnx2 = ($pbx2 - $movx) / $scal;
  my $wny1 = ($pby1 - $movy) / $scal; my $wny2 = ($pby2 - $movy) / $scal;
  if($pdat->{'inverty'}) {
    viewArea($cnvs, $wnx1,-$wny1, $wnx2,-$wny2, '-border' => $swch{'-border'});
  } else {
    viewArea($cnvs, $wnx1, $wny1, $wnx2, $wny2, '-border' => $swch{'-border'});
  }
}

sub viewArea {
  my($cnvs, $vwx1, $vwy1, $vwx2, $vwy2)= splice(@_, 0, 5);
  return() if(!defined($vwy2) || !$cnvs->type('all'));
  my %swch = ('-border' => 0.02, @_);
  $swch{'-border'} = 0 if($swch{'-border'} < 0);
  my $pdat = $cnvs->privateData();
  _new_bbox($cnvs) unless($pdat->{'bboxvalid'});
  ($vwx1, $vwx2) = ($vwx2, $vwx1) if($vwx1 > $vwx2);
  ($vwy1, $vwy2) = ($vwy2, $vwy1) if($vwy1 > $vwy2);
  my $bwid = $swch{'-border'} * ($vwx2 - $vwx1);
  my $bhit = $swch{'-border'} * ($vwy2 - $vwy1);
  $vwx1 -= $bwid; $vwx2 += $bwid;
  $vwy1 -= $bhit; $vwy2 += $bhit;
  my $scal = $pdat->{'scale'};
  my $movx = $pdat->{'movex'};  my $movy = $pdat->{'movey'};
  my $cnvx = $cnvs->canvasx(0); my $cnvy = $cnvs->canvasy(0);
  my $cnx1 = $vwx1 * $scal + $movx - $cnvx;
  my $cnx2 = $vwx2 * $scal + $movx - $cnvx;
  my $cny1 = $vwy1 * $scal + $movy - $cnvy;
  my $cny2 = $vwy2 * $scal + $movy - $cnvy;
  _view_area_canvas($cnvs, $cnx1, $cny1, $cnx2, $cny2);
}

sub _view_area_canvas {
  my($cnvs, $vwx1, $vwy1, $vwx2, $vwy2)= @_;
  return() unless($cnvs->type('all'));
  my $pdat = $cnvs->privateData();
  _new_bbox($cnvs) unless($pdat->{'bboxvalid'});
  my $bwid = $cnvs->cget('-borderwidth');
  my $cwid = $cnvs->width();  my $dltx = $cwid / 2 - ($vwx1 + $vwx2) / 2;
  my $chit = $cnvs->height(); my $dlty = $chit / 2 - ($vwy1 + $vwy2) / 2;
  my $midx = $cnvs->canvasx(0)  + $cwid  / 2; $vwx2++ if($vwx2 == $vwx1);
  my $midy = $cnvs->canvasy(0)  + $chit  / 2; $vwy2++ if($vwy2 == $vwy1);
  my $zumx = ($cwid - 2 * $bwid) / abs($vwx2 - $vwx1);
  my $zumy = ($chit - 2 * $bwid) / abs($vwy2 - $vwy1);
  my $zoom = ($zumx < $zumy) ? $zumx : $zumy;
  if($zoom > 0.999 && $zoom < 1.001) {
    $cnvs->SUPER::move('all', $dltx, $dlty);
  } else {
    $cnvs->SUPER::scale('all', $midx - $dltx - $dltx / ($zoom - 1), $midy - $dlty - $dlty / ($zoom - 1), $zoom, $zoom);
  }
  $pdat->{'movex'}  = ($pdat->{'movex'} + $dltx - $midx) * $zoom + $midx;
  $pdat->{'movey'}  = ($pdat->{'movey'} + $dlty - $midy) * $zoom + $midy;
  $pdat->{'scale'} *= $zoom;
  my($pbx1, $pby1, $pbx2, $pby2) = @{$pdat->{'bbox'}};
  $pbx1 = ($pbx1 + $dltx - $midx) * $zoom + $midx;
  $pbx2 = ($pbx2 + $dltx - $midx) * $zoom + $midx;
  $pby1 = ($pby1 + $dlty - $midy) * $zoom + $midy;
  $pby2 = ($pby2 + $dlty - $midy) * $zoom + $midy;
  $pdat->{'bbox'} =                   [$pbx1, $pby1, $pbx2, $pby2];
  $cnvs->configure('-scrollregion' => [$pbx1, $pby1, $pbx2, $pby2]);
  $cnvs->Callback('-changeView' => getView($cnvs)) if(defined($cnvs->cget('-changeView')));
}

sub _map_coords {
  my $cnvs = shift(); my @crds = (); my $chbx = 0;
  my $pdat = $cnvs->privateData();   my $xval = 1;
  my($pbx1, $pby1, $pbx2, $pby2)= @{$pdat->{'bbox'}};
  my $scal = $pdat->{'scale'};
  my $movx = $pdat->{'movex'};
  my $movy = $pdat->{'movey'};
  while(defined(my $argu = shift())) {
    if($argu !~ /^[+-.]*\d/) {
      unshift(@_, $argu); last();
    } else {
      if($xval) {
        $argu = $argu * $scal + $movx;
        if($pbx2 < $pbx1) { $pbx2 = $pbx1 = $argu; $chbx = 1; }
        if($argu < $pbx1) { $pbx1 =         $argu; $chbx = 1; }
        if($argu > $pbx2) { $pbx2 =         $argu; $chbx = 1; }
        $xval = 0;
      } else {
        if($pdat->{'inverty'}) {
          $argu = -$argu * $scal + $movy; #       invert y-coords
        } else {
          $argu =  $argu * $scal + $movy; # don't invert y-coords
        }
        if($pby2 < $pby1) { $pby2 = $pby1 = $argu; $chbx = 1; }
        if($argu < $pby1) { $pby1 =         $argu; $chbx = 1; }
        if($argu > $pby2) { $pby2 =         $argu; $chbx = 1; }
        $xval = 1;
      }
      push(@crds, $argu);
    }
  }
  if($chbx) {
    $pdat->{'bbox'} =                   [$pbx1, $pby1, $pbx2, $pby2];
    $cnvs->configure('-scrollregion' => [$pbx1, $pby1, $pbx2, $pby2]);
  }
  return(@crds, @_);
}

sub find {
  my($cnvs, @args)= @_;
  my $pdat = $cnvs->privateData();
  if($args[0] =~ /^(closest|above|below)$/i) {
    if(lc($args[0]) eq 'closest') {
      return() if(@args < 3);
      my $scal = $pdat->{'scale'};
      $args[1] = $args[1] * $scal + $pdat->{'movex'};
      if($pdat->{'inverty'}) {
        $args[2] = -$args[2] * $scal + $pdat->{'movey'};
      } else {
        $args[2] =  $args[2] * $scal + $pdat->{'movey'};
      }
    }
    my $recr = _killBand($cnvs);
    my $foun = $cnvs->SUPER::find(@args);
    _makeBand($cnvs) if($recr);
    return($foun);
  } else {
    if($args[0] =~ /^(enclosed|overlapping)$/i) {
      return() if(@args < 5);
      my $scal = $pdat->{'scale'};
      my $movx = $pdat->{'movex'};
      my $movy = $pdat->{'movey'};
      $args[1] = $args[1] * $scal + $movx;
      $args[3] = $args[3] * $scal + $movx;
      if($pdat->{'inverty'}) {
        $args[2] = -$args[2] * $scal + $movy;
        $args[4] = -$args[4] * $scal + $movy;
      } else {
        $args[2] =  $args[2] * $scal + $movy;
        $args[4] =  $args[4] * $scal + $movy;
      }
    }
    my $recr = _killBand($cnvs);
    my @foun = $cnvs->SUPER::find(@args);
    _makeBand($cnvs) if($recr);
    return(@foun);
  }
}

sub coords {
  my($cnvs, $tagg, @wcrd) = @_;
  return() unless($cnvs->type($tagg));
  my $pdat = $cnvs->privateData();
  my $scal = $pdat->{'scale'};
  my $movx = $pdat->{'movex'};
  my $movy = $pdat->{'movey'};
  if(@wcrd) {
    die "!*EROR*! Missing y-coordinate in call to coords()!\n" if(@wcrd % 2);
    my($cbx1, $cby1, $cbx2, $cby2)= _find_box($cnvs->SUPER::coords($tagg));
    my @ccrd = @wcrd;
    for(my $indx = 0; $indx < @ccrd; $indx += 2) {
      $ccrd[$indx    ] = $ccrd[$indx    ] * $scal + $movx;
      if($pdat->{'inverty'}) {
        $ccrd[$indx + 1] = -$ccrd[$indx + 1] * $scal + $movy;
      } else {
        $ccrd[$indx + 1] =  $ccrd[$indx + 1] * $scal + $movy;
      }
    }
    $cnvs->SUPER::coords($tagg, @ccrd);
    my($abx1, $aby1, $abx2, $aby2) = _find_box(@ccrd);
    _adjustBbox($cnvs, $cbx1, $cby1, $cbx2, $cby2, $abx1, $aby1, $abx2, $aby2);
  } else {
    @wcrd = $cnvs->SUPER::coords($tagg);
    die "!*EROR*! Missing y-coordinate in return value from SUPER::coords()!\n" if(@wcrd % 2);
    for(my $indx = 0; $indx < @wcrd; $indx += 2) {
      $wcrd[$indx    ] = ($wcrd[$indx    ] - $movx) / $scal;
      if($pdat->{'inverty'}) {
        $wcrd[$indx + 1] = 0 - ($wcrd[$indx + 1] - $movy) / $scal;
      } else {
        $wcrd[$indx + 1] =     ($wcrd[$indx + 1] - $movy) / $scal;
      }
    }
    if(@wcrd == 4 && ($wcrd[0] > $wcrd[2] || $wcrd[1] > $wcrd[3])) {
      my $type = $cnvs->type($tagg);
      if($type =~ /^(arc|oval|rectangle)$/) {
        ($wcrd[0], $wcrd[2]) = ($wcrd[2], $wcrd[0]) if($wcrd[0] > $wcrd[2]);
        ($wcrd[1], $wcrd[3]) = ($wcrd[3], $wcrd[1]) if($wcrd[1] > $wcrd[3]);
      }
    }
    return(@wcrd);
  }
  return();
}

sub scale {
  my($cnvs, $tagg, $xoff, $yoff, $xscl, $yscl) = @_;
  return() unless($cnvs->type($tagg));
  my $pdat = $cnvs->privateData();
  my $cnxo = $xoff * $pdat->{'scale'} + $pdat->{'movex'};
  my $cnyo = $yoff * $pdat->{'scale'} + $pdat->{'movey'};
  if($pdat->{'inverty'}) {
    $cnyo = -$yoff * $pdat->{'scale'} + $pdat->{'movey'};
  }
  if(lc($tagg) eq 'all') {
    $cnvs->SUPER::scale($tagg, $cnxo, $cnyo, $xscl, $yscl);
    my($pbx1, $pby1, $pbx2, $pby2) = @{$pdat->{'bbox'}};
    $pbx1 = ($pbx1 - $cnxo) * $xscl + $cnxo;
    $pbx2 = ($pbx2 - $cnxo) * $xscl + $cnxo;
    $pby1 = ($pby1 - $cnyo) * $yscl + $cnyo;
    $pby2 = ($pby2 - $cnyo) * $yscl + $cnyo;
    $pdat->{'bbox'} =                   [$pbx1, $pby1, $pbx2, $pby2];
    $cnvs->configure('-scrollregion' => [$pbx1, $pby1, $pbx2, $pby2]);
  } else {
    my($cbx1, $cby1, $cbx2, $cby2) = _find_box($cnvs->SUPER::coords($tagg));
    $cnvs->SUPER::scale($tagg, $cnxo, $cnyo, $xscl, $yscl);
    my $nwx1 = ($cbx1 - $cnxo) * $xscl + $cnxo;
    my $nwx2 = ($cbx2 - $cnxo) * $xscl + $cnxo;
    my $nwy1 = ($cby1 - $cnyo) * $yscl + $cnyo;
    my $nwy2 = ($cby2 - $cnyo) * $yscl + $cnyo;
    _adjustBbox($cnvs, $cbx1, $cby1, $cbx2, $cby2, $nwx1, $nwy1, $nwx2, $nwy2);
  }
}

sub move {
  my($cnvs, $tagg, $xval, $yval)= @_;
  my($cbx1, $cby1, $cbx2, $cby2)= _find_box($cnvs->SUPER::coords($tagg));
  my $scal = $cnvs->privateData->{'scale'};
  my $dltx = $xval * $scal;
  my $dlty = $yval * $scal;
  $cnvs->SUPER::move($tagg, $dltx, $dlty);
  my($nwx1, $nwy1, $nwx2, $nwy2)= ($cbx1 + $dltx, $cby1 + $dlty, $cbx2 + $dltx, $cby2 + $dlty);
  _adjustBbox($cnvs, $cbx1, $cby1, $cbx2, $cby2, $nwx1, $nwy1, $nwx2, $nwy2);
}

sub _adjustBbox {
  my($cnvs, $cbx1, $cby1, $cbx2, $cby2, $nwx1, $nwy1, $nwx2, $nwy2)= @_;
  my $pdat = $cnvs->privateData();
  my($pbx1, $pby1, $pbx2, $pby2) = @{$pdat->{'bbox'}};
  my $chbx = 0;
  if($nwx1 < $pbx1) { $pbx1 = $nwx1; $chbx = 1; }
  if($nwy1 < $pby1) { $pby1 = $nwy1; $chbx = 1; }
  if($nwx2 > $pbx2) { $pbx2 = $nwx2; $chbx = 1; }
  if($nwy2 > $pby2) { $pby2 = $nwy2; $chbx = 1; }
  if($chbx) {
    $pdat->{'bbox'} =                   [$pbx1, $pby1, $pbx2, $pby2];
    $cnvs->configure('-scrollregion' => [$pbx1, $pby1, $pbx2, $pby2]);
  }
  my $wmrg = 0.01 * ($pbx2 - $pbx1); $wmrg = 3 if($wmrg < 3); # width  margin
  my $hmrg = 0.01 * ($pby2 - $pby1); $hmrg = 3 if($hmrg < 3); # height margin
  if(($cbx1 - $wmrg < $pbx1 && $cbx1 < $nwx1) ||
     ($cby1 - $hmrg < $pby1 && $cby1 < $nwy1) ||
     ($cbx2 + $wmrg > $pbx2 && $cbx2 > $nwx2) ||
     ($cby2 + $hmrg > $pby2 && $cby2 > $nwy2)) {
    $pdat->{'bboxvalid'} = 0;
  }
}

sub bbox {
  my $cnvs = shift(); my $xact = 0;
  if($_[0] =~ /-exact/i) {
            shift();
    $xact = shift();
  }
  my @tags = @_;
  my $foun = 0;
  foreach(@tags) {
    if($cnvs->type($_)) { $foun = 1; last(); }
  }
  return() unless($foun);
  my $pdat = $cnvs->privateData();
  if(lc($tags[0]) eq 'all') {
    my($pbx1, $pby1, $pbx2, $pby2)= @{$pdat->{'bbox'}};
    my $scal = $pdat->{'scale'};
    my $movx = $pdat->{'movex'};
    my $movy = $pdat->{'movey'};
    my $wnx1 = ($pbx1 - $movx) / $scal; my $wnx2 = ($pbx2 - $movx) / $scal;
    my $wny1 = ($pby1 - $movy) / $scal; my $wny2 = ($pby2 - $movy) / $scal;
    ($wnx1, $wnx2) = ($wnx2, $wnx1) if($wnx2 < $wnx1);
    ($wny1, $wny2) = ($wny2, $wny1) if($wny2 < $wny1);
    return($wnx1, $wny1, $wnx2, $wny2);
  } else {
    my $onep = 1.0 / $pdat->{'scale'}; my $zfix = 0; # one pixel; zoom fix
    if($xact && $onep > 0.001) { zoom($cnvs, $onep * 1000); $zfix = 1; }
    my($cbx1, $cby1, $cbx2, $cby2)= _superBbox($cnvs, @tags);
    unless(defined($cbx1)) { # @tags exist but their bbox overflows as ints
      zoom($cnvs, 1 / ($onep * 1000)) if($zfix);
      return();
    }
    # If the error looks to be greater than 15%, do exact anyway
    if(!$xact && abs($cbx2 - $cbx1) < 27 && abs($cby2 - $cby1) < 27) {
      zoom($cnvs, $onep * 1000);
      my($nwx1, $nwy1, $nwx2, $nwy2)= _superBbox($cnvs, @tags);
      if(!defined($nwx1)) { # overflows ints so retreat to previous box
        zoom($cnvs, 1 / ($onep * 1000));
      } else {
        $zfix = 1;
        ($cbx1, $cby1, $cbx2, $cby2) = ($nwx1, $nwy1, $nwx2, $nwy2);
      }
    }
    my $scal = $pdat->{'scale'};
    my $movx = $pdat->{'movex'};
    my $movy = $pdat->{'movey'};
    $cbx1 = ($cbx1 - $movx) / $scal;
    $cbx2 = ($cbx2 - $movx) / $scal;
    if($pdat->{'inverty'}) {
      $cby1 = ($cby1 - $movy) / -$scal;
      $cby2 = ($cby2 - $movy) / -$scal;
    } else {
      $cby1 = ($cby1 - $movy) /  $scal;
      $cby2 = ($cby2 - $movy) /  $scal;
    }
    zoom($cnvs, 1 / ($onep * 1000)) if($zfix);
    if($pdat->{'inverty'}) {
      return($cbx1, $cby2, $cbx2, $cby1);
    } else {
      return($cbx1, $cby1, $cbx2, $cby2);
    }
  }
}

sub rubberBand {
  die "!*EROR*! Wrong number of args passed to rubberBand()!\n" unless(@_ == 2);
  my($cnvs, $step)= @_;
  my $pdat = $cnvs->privateData();
  return() if($step >= 1 && !defined($pdat->{'RubberBand'}));
  my $xevt = $cnvs->XEvent();
  my $xabs = abstractx($cnvs, $xevt->x());
  my $yabs = abstracty($cnvs, $xevt->y());
  if     ($step == 0) { # create anchor for rubberband
    _killBand($cnvs);
    $pdat->{'RubberBand'} = [$xabs, $yabs, $xabs, $yabs];
  } elsif($step == 1) { # update end of rubber band and redraw
    $pdat->{'RubberBand'}[2] = $xabs;
    $pdat->{'RubberBand'}[3] = $yabs;
    _killBand($cnvs);
    _makeBand($cnvs);
  } elsif($step == 2) { # done
    _killBand($cnvs) || return();
    my($pbx1, $pby1, $pbx2, $pby2) = @{$pdat->{'RubberBand'}};
    undef($pdat->{'RubberBand'});
    ($pbx1, $pbx2) = ($pbx2, $pbx1) if($pbx2 < $pbx1);
    ($pby1, $pby2) = ($pby2, $pby1) if($pby2 < $pby1);
    return($pbx1, $pby1, $pbx2, $pby2);
  }
}

sub _superBbox {
  my($cnvs, @tags)= @_;
  my $recr = _killBand($cnvs);
  my($cbx1, $cby1, $cbx2, $cby2)= $cnvs->SUPER::bbox(@tags);
  _makeBand($cnvs) if($recr);
  return($cbx1, $cby1, $cbx2, $cby2);
}

sub _killBand {
  my($cnvs)= @_;
  my $rbid = $cnvs->privateData->{'RubberBandID'};
  return(0) unless(defined($rbid));
  $cnvs->SUPER::delete($rbid);
  undef($cnvs->privateData->{'RubberBandID'});
  return(1);
}

sub _makeBand {
  my($cnvs)= @_;
  my $pdat = $cnvs->privateData();
  my $rbnd = $pdat->{'RubberBand'};
  die "!*EROR*! RubberBand is not defined!" unless(defined($rbnd));
  die "!*EROR*! RubberBand does not have 4 values!" if(@$rbnd != 4);
  my $scal = $pdat->{'scale'};
  my $movx = $pdat->{'movex'};
  my $movy = $pdat->{'movey'};
  my $rbx1 = $rbnd->[0] * $scal + $movx;
  my $rbx2 = $rbnd->[2] * $scal + $movx;
  my $rby1 = $rbnd->[1] * $scal + $movy;
  my $rby2 = $rbnd->[3] * $scal + $movy;
  my $colr = $cnvs->cget('-bandColor');
  my $rbid = $cnvs->SUPER::create('rectangle', $rbx1, $rby1, $rbx2, $rby2,
    '-outline' => $colr);
  $pdat->{'RubberBandID'} = $rbid;
}

sub eventLocation {
  my($cnvs)= @_;
  my $xevt = $cnvs->XEvent();
  return($cnvs->abstractx($xevt->x()), $cnvs->abstracty($xevt->y())) if(defined($xevt));
  return();
}

sub viewFit {
  my $cnvs = shift(); my $bord = 0.02;
  if(lc($_[0]) eq '-border') {
            shift();
    $bord = shift() if(@_);
    $bord = 0 if($bord < 0);
  }
  my @tags = @_;
  my $foun = 0;
  foreach(@tags) {
    if($cnvs->type($_)) { $foun = 1; last(); }
  }
  return() unless($foun);
  viewArea($cnvs, bbox($cnvs, @tags), '-border' => $bord);
}

sub pixelSize {
  my($cnvs)= @_;
  return(1.0 / $cnvs->privateData->{'scale'});
}

sub abstractx {
  my($cnvs, $xval)= @_;
  my $pdat = $cnvs->privateData();
  my $scal = $pdat->{'scale'};
  return() unless($scal);
  return(($cnvs->canvasx(0) + $xval - $pdat->{'movex'}) / $scal);
}

sub abstracty {
  my($cnvs, $yval)= @_;
  my $pdat = $cnvs->privateData();
  my $scal = $pdat->{'scale'};
  return() unless($scal);
  if($pdat->{'inverty'}) {
    return(0 - ($cnvs->canvasy(0) + $yval - $pdat->{'movey'}) / $scal);
  } else {
    return(    ($cnvs->canvasy(0) + $yval - $pdat->{'movey'}) / $scal);
  }
}

sub abstractxy {
  my($cnvs, $xval, $yval)= @_;
  my $pdat = $cnvs->privateData();
  my $scal = $pdat->{'scale'};
  return() unless($scal);
  if($pdat->{'inverty'}) {
    return(    ($cnvs->canvasx(0) + $xval - $pdat->{'movex'}) / $scal,
           0 - ($cnvs->canvasy(0) + $yval - $pdat->{'movey'}) / $scal);
  } else {
    return(    ($cnvs->canvasx(0) + $xval - $pdat->{'movex'}) / $scal,
               ($cnvs->canvasy(0) + $yval - $pdat->{'movey'}) / $scal);
  }
}

sub widgetx {
  my($cnvs, $xval)= @_;
  my $pdat = $cnvs->privateData();
  return($xval * $pdat->{'scale'} + $pdat->{'movex'} - $cnvs->canvasx(0));
}

sub widgety {
  my($cnvs, $yval)= @_;
  my $pdat = $cnvs->privateData();
  if($pdat->{'inverty'}) {
    return(-$yval * $pdat->{'scale'} + $pdat->{'movey'} - $cnvs->canvasy(0));
  } else {
    return( $yval * $pdat->{'scale'} + $pdat->{'movey'} - $cnvs->canvasy(0));
  }
}

sub widgetxy {
  my($cnvs, $xval, $yval)= @_;
  my $pdat = $cnvs->privateData();
  my $scal = $pdat->{'scale'};
  if($pdat->{'inverty'}) {
    return ( $xval * $scal + $pdat->{'movex'} - $cnvs->canvasx(0),
            -$yval * $scal + $pdat->{'movey'} - $cnvs->canvasy(0));
  } else {
    return ( $xval * $scal + $pdat->{'movex'} - $cnvs->canvasx(0),
             $yval * $scal + $pdat->{'movey'} - $cnvs->canvasy(0));
  }
}

my $cmap = 0; # 'cmap' is used to avoid calling _map_coords twice.

sub create {
  my($cnvs, $type)= splice(@_, 0, 2);
  my @narg = ($cmap) ? @_ : _map_coords($cnvs, @_);
  if     ($type eq 'rectangle') {
    $cnvs->_rect_to_poly(@narg);
  } elsif($type eq 'oval') {
    $cnvs->_oval_to_poly(@narg);
  } else {
    $cnvs->SUPER::create($type, @narg);
  }
}

sub createPolygon {
  my $cnvs = shift();
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $plid = $cnvs->SUPER::createPolygon(@narg);
  $cmap = 0;
  return($plid);
}

sub createRectangle {
  my $cnvs = shift();
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $rcid;
  if($cnvs->privateData->{'rect_to_poly'}) {
    $rcid = $cnvs->_rect_to_poly(@narg);
  } else {
    $rcid = $cnvs->SUPER::createRectangle(@narg);
  }
  $cmap = 0;
  return($rcid);
}

sub _rect_to_poly { # Transforms rectangle coords to poly coords.
  my $self = shift();
  my($left, $topp, $rite, $botm)= splice(@_, 0, 4);
    ($left, $rite) = ($rite, $left) if($rite < $left);
    ($topp, $botm) = ($botm, $topp) if($botm < $topp);
  $self->createPolygon($left, $topp, $rite, $topp,
                       $rite, $botm, $left, $botm, @_);
}

sub createArc {
  my $cnvs = shift();
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $arid = $cnvs->SUPER::createArc(@narg);
  $cmap = 0;
  return($arid);
}

sub createLine {
  my $cnvs = shift;
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $lnid = $cnvs->SUPER::createLine(@narg);
  $cmap = 0;
  return($lnid);
}

sub createOval {
  my $cnvs = shift;
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $ovid;
  if($cnvs->privateData->{'oval_to_poly'}) {
    $ovid = $cnvs->_oval_to_poly(@narg);
  } else {
    $ovid = $cnvs->SUPER::createOval(@narg);
  }
  $cmap = 0;
  return($ovid);
}

sub _oval_to_poly {
  my $self = shift();
  my($left, $topp, $rite, $botm)= splice(@_, 0, 4);
  my $stps = 127;
  if(lc($_[0]) eq '-steps') {
    shift(); $stps = shift();
  }
  my $xcnt = ($rite - $left) / 2;
  my $ycnt = ($botm - $topp) / 2;
  my @ptls;
  for my $indx (0..$stps) {
    my $thta = (PI * 2) * ($indx / $stps);
    my $xnew = $xcnt * cos($thta) - $xcnt + $rite;
    my $ynew = $ycnt * sin($thta) + $ycnt + $topp;
    push(@ptls, $xnew, $ynew);
  }
  push(@_, '-fill'   ,  undef ) unless(grep {/-fill/   } @_);
  push(@_, '-outline', 'black') unless(grep {/-outline/} @_);
  $self->createPolygon(@ptls, @_);
}

sub createText {
  my $cnvs = shift;
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $txid = $cnvs->SUPER::createText(@narg);
  $cmap = 0;
  return($txid);
}

sub createWindow {
  my $cnvs = shift;
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $wnid = $cnvs->SUPER::createWindow(@narg);
  $cmap = 0;
  return($wnid);
}

sub createBitmap {
  my $cnvs = shift;
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $bmid = $cnvs->SUPER::createBitmap(@narg);
  $cmap = 0;
  return($bmid);
}

sub createImage {
  my $cnvs = shift;
  my @narg = _map_coords($cnvs, @_);
  $cmap = 1;
  my $imid = $cnvs->SUPER::createImage(@narg);
  $cmap = 0;
  return($imid);
}

sub _get_CM { # Find the center of mass of a polygon.
  my($xcnt, $ycnt, $area);
  my $indx = 0;
  while($indx < $#_) {
    my $xzer = $_[$indx    ];
    my $yzer = $_[$indx + 1];
    my($xone, $yone);
    if($indx + 2 > $#_) {
      $xone = $_[0];
      $yone = $_[1];
    } else {
      $xone = $_[$indx + 2];
      $yone = $_[$indx + 3];
    }
    $indx += 2;
    my $aone = ($xzer + $xone) / 2;
    my $atwo = ($xzer**2 + $xzer*$xone + $xone**2)/6;
    my $athr = ($xzer*$yone + $yzer*$xone + 2*($xone*$yone + $xzer*$yzer))/6;
    my $ydlt = $yone - $yzer;
    $area += $aone * $ydlt;
    $xcnt += $atwo * $ydlt;
    $ycnt += $athr * $ydlt;
  }
  return(split(' ', sprintf("%.0f %0.f" => $xcnt/$area, $ycnt/$area)));
}

127;
