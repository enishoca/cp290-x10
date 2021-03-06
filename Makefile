
HOME = /usr2/foxharp
BIN = $(HOME)/bin
GROUP = sys
OWNER = bin

#	set DFLAGS equal to:
#	   -DSYSV	if using SYSTEM V
#	   -DVOID	if compiler doesn't understand 'void'
#	   -DMINIEXCH	if using the DEC mini-exchange
#	   -DXDIR=\"fullpath_name/x10\" if not using default of "." or
#		if not using $X10CONFIG variable
DFLAGS = -DSYSV -DPOSIX -DXDIR=\"$(HOME)/x10\" -DALLOW_SOCKET

CFLAGS = -g $(DFLAGS)
#LDFLAGS = -z -i
#LIBS = -lm -lc_s		# uncomment if using shared libraries
LIBS = -lm -lc

SRCS =	data.c date.c delete.c diagnstc.c dump.c fdump.c \
	finfo.c fload.c info.c getslot.c message.c miniexch.c \
	monitor.c prints.c readid.c reset.c schedule.c setclock.c \
	tty.c turn.c x10.c xread.c sunrise.c

OBJS =	data.o date.o delete.o diagnstc.o dump.o fdump.o \
	finfo.o fload.o info.o getslot.o message.o miniexch.o \
	monitor.o prints.o readid.o reset.o schedule.o setclock.o \
	tty.o turn.o x10.o xread.o sunrise.o

OTHERSRC = README REVIEW Makefile x10config sched sched_from_cron \
	monit x10biff x10.1 x10.h

EVERYTHING = $(OTHERSRC) $(SRCS)

x10:	$(OBJS)
	cc $(LDFLAGS) -o x10 $(OBJS) $(LIBS)
#	chgrp $(GROUP) x10
#	chmod 2755 x10
#	chown $(OWNER) x10

$(OBJS): x10.h

install: x10
	mv x10 $(BIN)

lint:
	lint $(DFLAGS) $(SRCS)

shar:	x10.shar.1 x10.shar.2

x10.shar.1:
	shar $(OTHERSRC) >x10.shar.1

x10.shar.2:
	shar $(SRCS) > x10.shar.2

bigshar:
	shar $(EVERYTHING) > x10.shar

# --tranform is a gnu tar feature
tar:
	tar -czvf x10.tar.gz --transform='s;^;x10/;' $(EVERYTHING)

touch:
	touch $(OTHERSRC)
	touch $(SRCS)

clean:
	rm -f *.o

clobber: clean
	rm -f x10

rcsdiffrw:
	@-for x in `$(MAKE) rw`	;\
	do	\
		echo 		;\
		echo $$x	;\
		echo =========	;\
		rcsdiff $$x	;\
	done 2>&1		;\
	echo			;\
	echo all done

list:
	@ls $(EVERYTHING) | more

rw:
	@ls -l $(EVERYTHING) | \
		egrep '^[^l].w' | \
		sed 's;.* ;;'   # strip to last space

update:
	nupdatefile.pl -r $(EVERYTHING)

populate: $(EVERYTHING)

$(EVERYTHING):
	co -r$(revision) $@

