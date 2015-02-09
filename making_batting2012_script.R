require(Lahman)
require(plyr)
require(ggplot2)

b0 <- battingStats()
b1 <- subset(b0, yearID == 2012 & !is.na(BA), select = c(playerID, BA))

f1 <- subset(Fielding, yearID == 2012, select = c(playerID, POS))
m1 <- subset(Master, select = c(playerID, bats))

t1 <- merge(b1, f1, all.x = TRUE, all.y = FALSE)
t1$POS2 <- with(t1, factor(ifelse(POS == "P", "P", 
                                  ifelse(POS == "C", "C", 
                                         ifelse(POS %in% c("LF", "OF", "RF"), "OF", "IN")))))
t1 <- subset(t1, !is.na(POS2), select = -POS)
names(t1)[3] <- "Position"

t2 <- merge(t1, m1, all.x = TRUE, all.y = FALSE)
t3 <- subset(t2, bats != "R")
t3 <- ddply(t3, .(playerID, Position), summarise, 
            BA = mean(BA), 
            Bats = unique(bats))
qplot(Position, BA, data = t3, fill = Bats, geom = "boxplot")
