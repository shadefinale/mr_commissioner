class League < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :teams
  has_many :roster_counts

  def current_year
    Time.now.year
  end

  def qb_count(year=current_year)
    self.roster_counts.find_by(:year => year).qb
  end

  def rb_count(year=current_year)
    self.roster_counts.find_by(:year => year).rb
  end

  def wr_count(year=current_year)
    self.roster_counts.find_by(:year => year).wr
  end

  def te_count(year=current_year)
    self.roster_counts.find_by(:year => year).te
  end

  def k_count(year=current_year)
    self.roster_counts.find_by(:year => year).k
  end

  def d_st_count(year=current_year)
    self.roster_counts.find_by(:year => year).d_st
  end

  def lb_count(year=current_year)
    self.roster_counts.find_by(:year => year).lb
  end

  def db_count(year=current_year)
    self.roster_counts.find_by(:year => year).db
  end

  def dl_count(year=current_year)
    self.roster_counts.find_by(:year => year).dl
  end

  def flex_count(year=current_year)
    self.roster_counts.find_by(:year => year).flex
  end

  def dt_count(year=current_year)
    self.roster_counts.find_by(:year => year).dt
  end

  def de_count(year=current_year)
    self.roster_counts.find_by(:year => year).de
  end

  def cb_count(year=current_year)
    self.roster_counts.find_by(:year => year).cb
  end

  def s_count(year=current_year)
    self.roster_counts.find_by(:year => year).s
  end

end
